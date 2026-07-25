
		global	ft_strcmp

		section	.text

ft_strcmp:	
		xor	ecx, ecx
.loop:		movzx	ax, byte [rdi + rcx]
		movzx	dx, byte [rsi + rcx]
		cmp	al, dl
		jnz	.sub
		test	al, dl
		jz	.sub
		inc	rcx
		jmp	.loop
.sub:
		sub	ax, dx 
		cwde		; convert word in ax into double-word in eax  === movsx	eax, ax  
		ret


;global ft_strcmp
;
;section .text
;
;ft_strcmp:
;	xor ecx, ecx
;	xor eax, eax
;
;.loop:
;	mov al, [rdi + rcx]
;	cmp al, byte [rsi + rcx]
;	jne .done
;	add ax, word [rsi + rcx]
;	test ax, ax
;	je .done
;	inc rcx
;	jmp .loop
;
;.done:
;	movzx rdx, byte [rsi + rcx]
;	sub eax, edx 
;	ret
