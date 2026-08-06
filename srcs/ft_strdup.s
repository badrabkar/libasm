; Author : babkar
; File : ft_strdup.s
; Description : x86_64 assembly implementation of the strdup() function call
;
; Arguments:
;  rdi: const char *s - file descriptor
;
; Return Value:
;  rax: holds a pointer to a new string which is a duplicate of the string s 


        global	ft_strdup
        extern	malloc
        extern	ft_strlen
        extern	ft_strcpy


        section	.text
ft_strdup:

        ; stack alignment and allocation of 16 bytes in the stack
        push rbp
        mov rbp, rsp
        sub rsp, 0x10 

        ; calculation the lenght of string to be allocated and adding 1 for \0
        mov [rsp + 0x8], rdi
        call ft_strlen
        mov rdi, rax
        inc rdi

        ; allocation of the string
        call malloc WRT ..plt
        test rax, rax
        je .exit

        ; copying the content of s in the new allocated memory
        mov rsi, [rsp + 0x8]
        mov rdi, rax
        call ft_strcpy

.exit:
        ; or we can do
        ; add rsp, 0x10 instead of mov rsp, rbp
        ; as long as we did not push anything in the stack  after the alignment
        mov rsp, rbp
        pop rbp
        ret

