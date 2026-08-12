;
; File: ft_write.s
; Description: x86_64 assembly implementation of write() system call.
;
; Arguments:
; rdi : int fd
; rsi : 
; rdx :


        global	ft_write
        extern __errno_location

        section	.text

ft_write:
        mov eax, 1
        syscall

        mov rcx, rax
        neg rcx
        cmp rax, 0
        jl .syscall_failure

        jmp .exit

.syscall_failure:
        call __errno_location WRT ..plt
        mov [rax], rcx
        mov rax, -1

.exit:
        ret

