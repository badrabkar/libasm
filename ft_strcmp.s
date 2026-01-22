global ft_strcmp

section .text

ft_strcmp:
	xor ecx, ecx ; setting the counter to 0
	xor eax, eax ; setting the accumulator rax to 0

.loop:
	mov al, [rdi + rcx]
	test al, byte [rsi + rcx] ; if one of the bytes equals to 0 ==> we reach the end of a string
	jz .done
	cmp al, byte [rsi + rcx] ; if the bytes are different we need to perform subtraction
	jne .done
	inc rcx
	jmp .loop
	
.done:
	movzx	rdx, byte [rsi + rcx]
	sub		rax, rdx		
	ret
