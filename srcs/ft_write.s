
        global	ft_write

        section	.text
        extern __errno_location

ft_write:
        mov eax, 1
        syscall
        mov rcx, rax
        neg rcx
        cmp rax, 0
        jl .done
        ret
.done:
        call __errno_location WRT ..plt
        mov [rax], rcx
        mov rax, -1
        ret

