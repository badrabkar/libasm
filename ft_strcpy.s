global	ft_strcpy	

section .text
		
ft_strcpy:
	xor ecx, ecx		; initialize the counter by 0	

.loop:
	mov al, [rsi + rcx] ;load from memory
	mov [rdi + rcx], al ;store the byte into the memory pointed by [rdi + rdx]
	cmp al, 0
	je .done
	inc rcx
	jmp .loop

.done:
	mov rax, rdi
	ret	
