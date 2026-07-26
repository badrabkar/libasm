
        global	ft_strcmp

        section	.text

ft_strcmp:
.loop:
        mov	al, byte [rdi]
        mov	dl, byte [rsi]
        cmp	al, dl
        jnz	.sub
        test	al, al
        jz	.sub
        inc rdi
        inc rsi
        jmp	.loop
.sub:
        movzx eax, al
        movzx edx, dl
        sub eax, edx
        ret

