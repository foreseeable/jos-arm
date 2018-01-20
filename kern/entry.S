#include "inc/memlayout.h"
#include "inc/mmu.h"
#define	RELOC(x) ((x) - KERNBASE)
// To keep this in the first portion of the binary.
.text
 
// Make _start global.
.globl _start
_start = RELOC(entry)
.globl entry
 
// Entry point for the kernel.
// r15 -> should begin execution at 0x8000.
// r0 -> 0x00000000
// r1 -> 0x00000C42
// r2 -> 0x00000100 - start of ATAGS
// preserve these registers as argument for kernel_main
entry:
    mrc p15, 0, r0, c0, c0, 5
    tst r0, #3
    bne halt
	// turn on mmu
	ldr r0, =RELOC(entry_pgdir)
	mcr p15, 0, r0, c2, c0, 0

	mov r0, #0xFFFFFFFF
	mcr p15, 0, r0, c3, c0, 0

	mrc p15, 0, r0, c1, c0, 0
	orr r0, r0, #0x1
	mcr p15, 0, r0, c1, c0, 0


	//Jump up above KERNBASE 
	ldr lr, =relocated
	bx lr

relocated:
	ldr sp, =bootstacktop  // Setup the stack.
	bl arm_init
halt:
	wfe
	b halt



	
.data
// boot stack
         .p2align        20         // force page alignment
         .globl          bootstack
bootstack:
         .space          0x8000 
         .globl          bootstacktop
bootstacktop:
