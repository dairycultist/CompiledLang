.section	__TEXT,__cstring,cstring_literals

string:
	.asciz	"cat: %d\n"



.section	__TEXT,__text,regular,pure_instructions

.globl	_main
_main:
	pushq	%rbp				# store stack
	pushq	%r15
	pushq	%rbx

	movl	$10, %ebx			# load 10 into... something
	leaq	string(%rip), %r15	# load address of string into r15
loop:
	movq	%r15, %rdi			# load address of string into rdi (special address for _printf)
	movl	%ebx, %esi
	callq	_printf

	decl	%ebx				# decrement
	cmpl	$0, %ebx			# <
	ja		loop
	
	popq	%rbx				# restore stack
	popq	%r15
	popq	%rbp
	retq