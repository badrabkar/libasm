; ===========================================================================
; File:
; ft_atoi_base_bonus.s
; Author:
; babkar
; Date:
; 2026-08-06
; Description:
; - function that converts the initial portion of the string pointed to by str
; into an integer representation.
; - function prototype:
; int ft_atoi_base(char *str, char *base)
; - str is in a specific base, given as a second parameter.
; - Except for the base rule, the function should behave exactly like ft_atoi.
; - rdi - char *str the string containing the numbers
; - rsi - char *base
; ===========================================================================

        extern	ft_strlen

        section	.text
        global	ft_atoi_base

check_base_validation:
; epilogue
        push rbp
        mov rbp, rsp
        sub rsp , 0x110                ; allocates an array of 256 bytes

        call ft_strlen
        mov [rsp], rax                 ; save the length of the base
        test rax, rax                  ; check if the base is empty
        jz .invalid_base
        cmp rax, 1                     ; check if the base contains one character
        jz .invalid_base

        mov rcx, 0x10
.zero_out_array:
        cmp rcx, 0x100
        jz .zero_out_array_break
        mov qword [rsp + rcx], 0
        add rcx, 0x8
        jmp .zero_out_array
.zero_out_array_break:
        xor ecx, ecx

.check_base_validity:
        cmp rcx, [rbp - 0x110]         ; check the end of the base
        jz .check_base_validity_break

        movzx rax, byte [rdi + rcx]
        cmp byte [rsp + rax + 0x16], 0x1 ; duplicate characters found
        jz .invalid_base

        cmp al, 32                     ; base[i] <= ' ' error
        jle .invalid_base
        cmp al, 126                    ; base[i] > 126 error
        jg .invalid_base
        cmp al, 43                     ; base[i] == '+'
        je .invalid_base
        cmp al, 45                     ; base[i] == '-'
        je .invalid_base

        mov byte [rsp + rax + 0x16], 0x1 ; array[0] = 1
        inc rcx

        jmp .check_base_validity

.check_base_validity_break:
        mov al, 0
        jmp .epilogue

.invalid_base:
        mov al, 1

.epilogue:
        mov rsp , rbp
        pop rbp
        ret

ft_atoi_base:
        push rdi
        push rsi

        pop rdi
        call check_base_validation
        test al, al
; jnz .invalid_base

        pop rsi

        mov rdi, rax
        mov rax, 60
        syscall

.invalid_base:
        xor eax, eax
        ret

.success:
        ret

