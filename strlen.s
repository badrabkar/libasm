
global ft_strlen

section	.text
ft_strlen:
	xor eax, eax
	mov cl , [rdi] 

	loop:
	cmp cl, 0x0
	jz .exit
	add rax, 0x1
	mov cl, [rdi + rax]
	jmp loop

	.exit:
	ret

