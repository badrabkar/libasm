
global ft_strlen

section	.text
;_start:
;	mov rdi, string
;	call _strlen
;	mov rdi, rax
;	mov rax, 60
;	syscall
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

;section .data
;string:
;	db "badr", 0
