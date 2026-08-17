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
; prologue
        push rbp
        mov rbp, rsp
        sub rsp , 0x110                ; allocates an array of 256 bytes

        mov [rsp + 0x8], rdi           ; rdi (caller-saved reg) we must preserve it
        call ft_strlen
        mov rdi, [rsp + 0x8]           ; recover char *base into rdi
        mov [rsp], rax                 ; save the length of the base
        test rax, rax                  ; check if base_len == 0
        jz .invalid_base
        cmp rax, 1                     ; check if base_len == 1
        jz .invalid_base

; initializing the hashtable by zero
        mov rcx, 0x10
.clear_array:
        cmp rcx, 0x110
        jz .clear_array_break

        mov qword [rsp + rcx], 0       ; insert 0 to 8 bytes to save loop cycles
        add rcx, 0x8

        jmp .clear_array
.clear_array_break:
        xor ecx, ecx

.loop:
        cmp rcx, [rbp - 0x110]         ; [rbp - 0x110] = [rsp] = base_len check the end of the base
        jz .loop_break

        movzx rax, byte [rdi + rcx]
        cmp byte [rsp + rax + 0x10], 0x1 ; duplicate character found
        jz .invalid_base

        cmp al, 32                     ; base[i] <= ' ' error
        jbe .invalid_base              ; similar to jle for unsigned
        cmp al, 126                    ; base[i] > 126 error
        ja .invalid_base               ; similar to jg for unsigned
        cmp al, 43                     ; base[i] == '+'
        je .invalid_base
        cmp al, 45                     ; base[i] == '-'
        je .invalid_base

        mov byte [rsp + rax + 0x10], 0x1 ; array[char] = 1 mark the char as seen
        inc rcx

        jmp .loop

.loop_break:
        xor eax, eax
        jmp .epilogue

.invalid_base:
        mov eax, 1

.epilogue:
        mov rsp, rbp
        pop rbp
        ret

escape_whitespaces:
.loop:
        movzx rax, byte [rdi + rcx]

        test al, al                    ; check if we reach the end of *base
        je .loop_break
        cmp al, 0x20                   ; check if the char is a SPACE = 32
        jne .loop_break
        cmp al, 0x0A
        jne .loop_break
        cmp al, 0x0B
        jne .loop_break
        cmp al, 0x0C
        jne .loop_break
        cmp al, 0x0D
        jne .loop_break

        inc ecx

        jmp .loop

.loop_break:
        mov eax, ecx
        ret

get_number_sign:
        xor ecx, ecx
        mov edx, 1
.loop:
        movzx rax, byte [rdi + rcx]
        test al, al
        je .loop_break

        cmp al, 43                     ; check if char == +
        jnz .loop_break
        cmp al, 45                     ; check if char == -
        jnz .loop_break
        je .track_minus

        inc rcx

        jmp .loop

.track_minus:
        neg edx
        inc rcx
        jmp .loop

.loop_break:
        mov eax, edx                   ; store the signedness in the top of the stack
        ret

get_char_base_index:

        xor ecx, ecx
.search_index:
        movzx rax, byte [rsi + rcx]
        test al, al
        je .done
        cmp al, dil
        je .done

        inc rcx

        jmp .search_index
.done:
        mov rax, rcx
        ret

ft_atoi_base:
; rdi contains str
; rsi contains base

; [rsp] will be used for swaping betweeing rdi and rsi
; [rsp + 0x8] will store the sign
; [rsp + 0x10] will store base len
; [rsp + 0x18] will store index of the char from the base
; [rsp + 0x20] will store res
; rcx the counter

; prologue
        push rbp
        mov rbp, rsp
        sub rsp, 0x20                  ; allocate (4 *8 bytes) in the stack
        mov r10d, 0

        mov [rsp], rdi
        mov rdi, rsi

; check if the base contains more than a character
        call ft_strlen
        cmp rax, 1
        jle .done
        mov [rsp + 0x10], rax

        call check_base_validation
        test al, al
        jnz .done

        mov rdi, [rsp]                 ; restore rdi value str
; escape whitespaces
; escape_whitespaces(char *str-rdi, int counter- ecx)
        call escape_whitespaces
        mov ecx, eax

; get number signedness
        call get_number_sign
        mov dword [rsp + 0x8], eax

; number conversion
; the logic of converting str into int
; number = 0
; loop
; index = get_char_base_index(
; number *= base_len
; number += index
; str++
; endloop

        mov [rsp], rdi
.loop:
        movzx rdi, byte [rsp + rcx]
        test dil, dil
        je .done

; int-eax get_char_base_index(char c-rdi, char *base-rsi)
        call get_char_base_index
        cmp eax, 0
        jl .done

; number-[rsp + 0x20]
; index-[rsp + 0x18]
; base_len-[rsp + 0x10]
        mov dword [rsp + 0x18], eax    ; store the index
        mov eax, r10d                  ; eax = number
        mul dword [rsp + 0x10]         ; eax * [rsp + 0x10] == number * base_len
        add eax, [rsp + 0x18]          ; eax = eax + index(base[index] == char)
        mov r10d , eax

        inc rcx

        jmp .loop

.done:
        mov eax, r10d
        mul dword [rsp + 0x8]
; epilogue
        mov rsp, rbp
        pop rbp
        ret
