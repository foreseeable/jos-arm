#
# This makefile system follows the structuring conventions
# recommended by Peter Miller in his excellent paper:
#
#	Recursive Make Considered Harmful
#	http://aegis.sourceforge.net/auug97.pdf
#
OBJDIR := obj

# Run 'make V=1' to turn on verbose commands, or 'make V=0' to turn them off.
ifeq ($(V),1)
override V =
endif
ifeq ($(V),0)
override V = @
endif

-include conf/env.mk

LABSETUP ?= ./

TOP = .

# try to generate a unique GDB port
GDBPORT	:= $(shell expr `id -u` % 5000 + 25000)

CC	:= $(GCCPREFIX)gcc -pipe
AS	:= $(GCCPREFIX)as
AR	:= $(GCCPREFIX)ar
LD	:= $(GCCPREFIX)ld
OBJCOPY	:= $(GCCPREFIX)objcopy
OBJDUMP	:= $(GCCPREFIX)objdump
NM	:= $(GCCPREFIX)nm

# Native commands
NCC	:= gcc $(CC_VER) -pipe
NATIVE_CFLAGS := $(CFLAGS) $(DEFS) $(LABDEFS) -I$(TOP) -MD -Wall
TAR	:= gtar
PERL	:= perl

# Compiler flags
# -fno-builtin is required to avoid refs to undefined functions in the kernel.
# Only optimize to -O1 to discourage inlining, which complicates backtraces.
CFLAGS := $(CFLAGS) -O1 -fno-builtin -I$(TOP) -MD
CFLAGS += -fno-omit-frame-pointer
CFLAGS += -Wall -Wno-format -Wno-unused -gstabs -fpic -ffreestanding -mcpu=arm1176jzf-s
# division support

LDFLAGS :=
# LDFLAGS := -m elf_arm

# Lists that the */Makefrag makefile fragments will add to
OBJDIRS :=

# Make sure that 'all' is the first target
all:

# Eliminate default suffix rules
.SUFFIXES:

# Delete target files if there is an error (or make is interrupted)
.DELETE_ON_ERROR:

# make it so that no intermediate .o files are ever deleted
.PRECIOUS: %.o $(OBJDIR)/boot/%.o $(OBJDIR)/kern/%.o \
	   $(OBJDIR)/lib/%.o $(OBJDIR)/fs/%.o $(OBJDIR)/net/%.o \
	   $(OBJDIR)/user/%.o

KERN_CFLAGS := $(CFLAGS) -DJOS_KERNEL -gstabs -std=gnu99

# Include Makefrags for subdirectories
include kern/Makefrag

QEMUOPTS = -kernel $(OBJDIR)/kern/kernel -cpu arm1176 -m 256 -M raspi2 -serial stdio -gdb tcp::$(GDBPORT)
IMAGES = $(OBJDIR)/kern/kernel

.gdbinit: .gdbinit.tmpl
	sed "s/localhost:1234/localhost:$(GDBPORT)/" < $^ > $@

gdb:
	arm-none-eabi-gdb -x .gdbinit

pre-qemu: .gdbinit

qemu: $(IMAGES) pre-qemu
	$(QEMU) $(QEMUOPTS)

qemu-gdb: $(IMAGES) pre-qemu
	@echo "***"
	@echo "*** Now run 'make gdb'." 1>&2
	@echo "***"
	$(QEMU) $(QEMUOPTS) -S

# For deleting the build
clean:
	rm -rf $(OBJDIR) .gdbinit jos.in qemu.log

realclean: clean
	rm -rf lab$(LAB).tar.gz \
		jos.out $(wildcard jos.out.*) \
		qemu.pcap $(wildcard qemu.pcap.*) \
		myapi.key

distclean: realclean
	rm -rf conf/gcc.mk

grade:
	@echo $(MAKE) clean
	@$(MAKE) clean || \
	  (echo "'make clean' failed.  HINT: Do you have another running instance of JOS?" && exit 1)
	./grade-lab$(LAB) $(GRADEFLAGS)

tarball: handin-check
<<<<<<< HEAD
	git archive --format=tar HEAD > lab$(LAB)-handin.tar
	git diff $(UPSTREAM)/lab$(LAB) > /tmp/lab$(LAB)diff.patch
	tar -rf lab$(LAB)-handin.tar /tmp/lab$(LAB)diff.patch
	gzip -c lab$(LAB)-handin.tar > lab$(LAB)-handin.tar.gz
	rm lab$(LAB)-handin.tar
	rm /tmp/lab$(LAB)diff.patch

tarball-pref: handin-check
	@SUF=$(LAB); \
	if test $(LAB) -eq 3 -o $(LAB) -eq 4; then \
		read -p "Which part would you like to submit? [a, b, c (lab 4 only)]" p; \
		if test "$$p" != a -a "$$p" != b; then \
			if test ! $(LAB) -eq 4 -o ! "$$p" = c; then \
				echo "Bad part \"$$p\""; \
				exit 1; \
			fi; \
		fi; \
		SUF="$(LAB)$$p"; \
		echo $$SUF > .suf; \
	else \
		rm -f .suf; \
	fi; \
	git archive --format=tar HEAD > lab$(LAB)-handin.tar
	git diff $(UPSTREAM)/lab$(LAB) > /tmp/lab$(LAB)diff.patch
	tar -rf lab$(LAB)-handin.tar /tmp/lab$(LAB)diff.patch
	gzip -c lab$(LAB)-handin.tar > lab$(LAB)-handin.tar.gz
	rm lab$(LAB)-handin.tar
	rm /tmp/lab$(LAB)diff.patch

myapi.key: warn
	@echo Get an API key for yourself by visiting $(WEBSUB)/
	@read -p "Please enter your API key: " k; \
	if test `echo -n "$$k" |wc -c` = 32 ; then \
		TF=`mktemp -t tmp.XXXXXX`; \
		if test "x$$TF" != "x" ; then \
			echo -n "$$k" > $$TF; \
			mv -f $$TF $@; \
		else \
			echo mktemp failed; \
			false; \
		fi; \
	else \
		echo Bad API key: $$k; \
		echo An API key should be 32 characters long.; \
		false; \
	fi;

warn:
	@echo; \
	echo "[31m******* WARNING *********"; \
	echo "this is the 2016 6.828 lab"; \
	echo "******* WARNING ********* [39m"; \
	echo; \

#handin-prep:
#	@./handin-prep


# This magic automatically generates makefile dependencies
# for header files included from C source files we compile,
# and keeps those dependencies up-to-date every time we recompile.
# See 'mergedep.pl' for more information.
$(OBJDIR)/.deps: $(foreach dir, $(OBJDIRS), $(wildcard $(OBJDIR)/$(dir)/*.d))
	@mkdir -p $(@D)
	@$(PERL) mergedep.pl $@ $^

-include $(OBJDIR)/.deps

always:
	@:

.PHONY: all always \
	handin git-handin tarball tarball-pref clean realclean distclean grade handin-prep handin-check \
warn
=======
	git archive --format=tar HEAD | gzip > lab$(LAB)-handin.tar.gz
>>>>>>> a57a119
