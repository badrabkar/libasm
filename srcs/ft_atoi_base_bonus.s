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
        ;prologue
        push rbp
        mov rbp, rsp
        sub rsp , 0x110                ; allocates an array of 256 bytes

        mov [rsp + 0x8], rdi            ; rdi (caller-saved reg) we must preserve it
        call ft_strlen
        mov rdi, [rsp + 0x8]           ; recover char *base into rdi 
        mov [rsp], rax                 ; save the length of the base
        test rax, rax                  ; check if base_len == 0
        jz .invalid_base
        cmp rax, 1                     ; check if base_len == 1
        jz .invalid_base

        ; initializing the hashtable by zero
        mov rcx, 0x10
.zero_out_array:
        cmp rcx, 0x110
        jz .zero_out_array_break

        mov qword [rsp + rcx], 0        ; insert 0 to 8 bytes to save loop cycles 
        add rcx, 0x8

        jmp .zero_out_array
.zero_out_array_break:
        xor ecx, ecx

.check_base_validity:
        cmp rcx, [rbp - 0x110]         ; [rbp - 0x110] = [rsp] = base_len check the end of the base
        jz .check_base_validity_break

        movzx rax, byte [rdi + rcx]
        cmp byte [rsp + rax + 0x10], 0x1 ; duplicate character found
        jz .invalid_base

        cmp al, 32                     ; base[i] <= ' ' error
        jbe .invalid_base               ; similar to jle for unsigned 
        cmp al, 126                    ; base[i] > 126 error
        ja .invalid_base                ; similar to jg for unsigned
        cmp al, 43                     ; base[i] == '+'
        je .invalid_base
        cmp al, 45                     ; base[i] == '-'
        je .invalid_base

        mov byte [rsp + rax + 0x10], 0x1 ; array[char] = 1 mark the char as seen
        inc rcx

        jmp .check_base_validity

.check_base_validity_break:
        xor eax, eax
        jmp .epilogue

.invalid_base:
        mov eax, 1

.epilogue:
        mov rsp , rbp
        pop rbp
        ret

ft_atoi_base:
        ;prologue
        push rdi
        push rsi


        mov rdi, [rsp]
        call check_base_validation
        test al, al
        jnz .invalid_base



        mov rdi, [rsp + 0x8]
        mov rsi, [rsp]

        // escape whitespaces
        xor ecx, ecx    ;set the counter to 0

.esc_spaces: 
        movxz rax, byte [rdi + rcx]

        test al, al             ; check if we reach the end of *base
        je .failure
        cmp al, 0x20            ; check if the char is a SPACE = 32
        jne .esc_spaces_break
        cmp al, 0x0A 
        jne .esc_spaces_break
        cmp al, 0x0B 
        jne .esc_spaces_break
        cmp al, 0x0C
        jne .esc_spaces_break
        cmp al, 0x0D
        jne .esc_spaces_break

        inc rcx

        jmp .esc_spaces
.esc_spaces_break:
        xor ecx, ecx
        mov ebx, 1

.number_signedness:
        movxz rax, byte [rdi + rcx]
        test al, al
        je .failure

        cmp al, 43              ; check if char == +
        jnz .number_signedness_break
        cmp al, 45              ; check if char == -
        jnz .number_signedness_break
        je .track_minus
        
        inc rcx

        jmp .number_signedness

.track_minus:
        neg rbx
        inc rcx
        jmp .number_signedness

.number_signedness_break;
        mov qword [rsp], rbx          ; store the signedness in the top of the stack
        xor ecx, ecx

.number_conversion:
        movxz rbx, byte [rdi + rcx]
        test bl, bl
        je .success
        call get_charindex_base

        mov rbx, [

        jmp .number_conversion




get_charindex_base:

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




        ;epilogue
        pop rsi
        pop rdi

        mov rdi, rax
        mov rax, 60
        syscall

.failure:
        xor eax, eax
        ret

.success:
        mov rbx, qword [rsp]
        mul rbx
        ret
