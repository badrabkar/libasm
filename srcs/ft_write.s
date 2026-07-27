
        global	ft_write
        extern  __errno_location 

        section	.text

ft_write:
        mov     rax, 1
        syscall
        cmp rax, -1
        jz .done
        ret
.done:

        call __errno_location
        ret

