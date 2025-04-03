.section	__TEXT,__cstring,cstring_literals

string:
	.asciz	"cat: %d\n"

#bytes:
#	.byte 10, 10



.section	__TEXT,__text,regular,pure_instructions

.globl	_main
_main:
	push	%rbp				# store stack
	push	%r15
	push	%rbx

	mov		$10, %ebx			# load 10 into... something
	lea		string(%rip), %r15	# load address of string into r15
loop:
	mov		%r15, %rdi			# load address of string into rdi (special address for _printf)
	mov		%ebx, %esi
	call	_printf

	dec		%ebx				# decrement
	cmp		$0, %ebx			# <
	ja		loop
	
	pop		%rbx				# restore stack
	pop		%r15
	pop		%rbp
	ret