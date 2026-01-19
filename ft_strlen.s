global ft_strlen 

section	.text

ft_strlen:
	xor eax, eax

loop:
	cmp byte [rdi + rax], 0x0
	je done
	add rax, 0x1
	jmp loop

done:
	ret
