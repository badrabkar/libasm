global ft_strcmp

section .text

ft_strcmp:
	xor ecx, ecx
	xor eax, eax

.loop:
	mov al, [rdi + rcx]
	cmp al, byte [rsi + rcx]
	jne .done
	add ax, word [rsi + rcx]
	test ax, ax
	je .done
	inc rcx
	jmp .loop

.done:
	movzx rdx, byte [rsi + rcx]
	sub eax, edx 
	ret
