; Author : babkar
; File : ft_read.s
; Description : x86_64 assembly implementation of the read() system call
;
; Arguments:
;  rdi: int fd - file descriptor
;  rsi: void *buf - buffer to store the count bytes read
;  rdx: size_t count - number of bytes read
;
; Return Value:
;  rax: on success, the number of bytes read.
;       on error, -1


        global	ft_read
        extern	__errno_location

        section	.text
ft_read:
        xor eax, eax            ; setting rax to 0 system call for read
        syscall                 ; invoke operating system to do the read

        cmp rax, 0              ; checking the sign of the return value
        jl .syscall_failure     ; jmp to syscall_failure branch when negative value is returned

        ret                     ; nb of bytes read returned

.syscall_failure:
        neg rax         ; on error negative values from -1 to -4095 are returned, we
        push rax        ; saving rax in the stack while aligning it

        call __errno_location WRT ..plt       
        pop rcx                 ; retrieving old rax return value in rcx 

        mov dword [rax], ecx    ; address of errno is stroed in rax we set it to rcx
        mov rax, -1             ; -1 is set to rax

        ret                     ; -1 returned 

