
        global	ft_strcpy

        section	.text
ft_strcpy:
        xor	ecx, ecx
.loop:
        mov	al, byte [rsi + rcx]
        mov	byte [rdi + rcx], al
        test	al, al
        jz	.done
        inc	rcx
        jmp	.loop

.done:

        mov	rax, rdi
        ret

