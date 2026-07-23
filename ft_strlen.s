global ft_strlen 

section	.text

;ft_strlen:
;	xor eax, eax
;
;.loop:
;	cmp byte [rdi + rax], 0
;	je .done
;	inc rax
;	jmp .loop

ft_strlen:
	mov	rax, rdi	
.loop:
	cmp	byte [rax], 0 
	jz	.done
	inc	rax
	jmp	.loop

.done:
	sub	rax, rdi
	ret
