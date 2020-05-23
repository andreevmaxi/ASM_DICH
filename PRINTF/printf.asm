section .text
global PRINTF

;==================================================================================================
;   Printing string in cmd
;
;   ENTRY:  rsi - address of format string
;   EXIT: -
;   DESTR:  rsi, rdi, rax, rbx, rcx, rdx, r8, r9, r10, r11, r12
;==================================================================================================
PRINTF:
    push rbp                            ; stack frame
    mov rbp, rsp

    mov r12, BUFFER                     ; setting our printf buffer
    mov rdi, rsi                        ; rdi = adress of format string
    call STRLEN

    mov r11, r12                        ; r11 = start of buffer
    xor rbx, rbx                        ; rbx = 0
    inc rbx                             ; for skipping return adress
    inc rbx                             ; for skipping rbp saving
    mov rdi, rsi                        ; rdi = adress of format string
    PROCESSING:
        mov rsi, rdi                    ; rsi = start of our progress

        cld
        mov al, '%'                     ; for searching next flag
        repne scasb                     ; finding next % or end of the string
        mov r8, rdi                     ; =
        sub r8, rsi                     ; =
        dec r8                          ; r8 = number of elemens between now progress and next @

        mov r9, rdi                     ; saving rdi...
        mov rdi, r11                    ; picking rdi to write in buffer
        cmp rcx, 0                      ; if we are at the end of string than we exit
        je .LAST_STEP

        mov r10, rcx                    ; saving rcx...
        mov rcx, r8                     ; rcx = number of elemmens between now progress and next @
        mov al, [r9]                    ; comparing flags
        xor rdx, rdx                    ; if %% flag, than our flag adress operand = 0. 
        cmp al, '%'                     ; if ==, than we need to jmp to % print
        je .BUFF_PRINT                  ; =

        lea rdx, [rbp + 8 * rbx]        ; rdx = adress of now operand
        inc rbx                         ; next step in stack of adresses
        .BUFF_PRINT:
            call FLAG_PRINT             ; writing now part of our str in buffer

        mov r11, rdi                    ; saving new buffer...
        mov rdi, r9                     ; loading quicksave of rdi
        inc rdi                         ; because we proceded flag char
        mov rcx, r10                    ; loading quicksave of rcx
        dec rcx                         ; because we proceded flag char
        jmp PROCESSING                  ; because we did everything we needed to do in this part of format

        .LAST_STEP:
            inc r8                      ; because in scasb we got 0, but we decrised it(if it's empty)
            mov rcx, r8                 ; rcx = number of last symbols
            cld
            rep movsb
            pop rbp

        mov rsi, BUFFER                 ; retrieving the buffer pointer
        call BUFFER_PRINT               ; writing the last chars
        mov rdi, r12                    ; =
        xor rax, rax                    ; =
        mov rcx, BSIZE                  ; =
        rep stosb                       ; clearing buffer

        ret

;==================================================================================================
;   Prints chars from flag in buffer
;
;   ENTRY:  al  - char of our flag
;           r12 - start of buffer
;           rcx - number chars to write in buffer before next %
;           rdi - end of buffer
;           rsi - adress of format str
;           rdx - adress of now operand
;           
;   EXIT:   rdi - end of buffer
;   DESTR:  r8, rax, rcx, rsi, rdi
;==================================================================================================
FLAG_PRINT:
    push rsi                        ; =
    push rax                        ; =
    push rdx                        ; quicksaving...

    mov rdx, rcx                    ; =
    call CHECK_CAP                  ; cheking capasity

    pop rdx                         ; =
    pop rax                         ; =
    pop rsi                         ; loading back our registers
    
    cld
    rep movsb                       ; printing chars before %
    cmp rdx, 0                      ; =
    je PERC                         ; if flag is %, than we just print

    sub al, 'a'                     ; to get index in jump table
    mov rax, [JTABLE + 8 * rax]     ; rax = mark of printing
    jmp rax                         ; and jumping to it

    PERC:
        mov rcx, 1                  ; =
        call CHECK_CAP              ; checking fit 
        
        mov [rdi], byte '%'         ; printing % to buffer
        inc rdi
        ret

    CHAR:
        mov rcx, 1                  ; =
        mov r8, rdx                 ; =
        call CHECK_CAP              ; checking fit 
        mov rdx, r8                 ; and returning rdx

        mov rax, [rdx]              ; =
        stosb                       ; printing char to buffer
        ret
    
    ERR:
        mov rcx, 5                  ; rcx = length of ERR_STR

        mov rdx, 5                  ; rdx = length for CHECK_CAP
        mov r8, rdi                 ; =         
        call CHECK_CAP              ; checking fit 

        mov rsi, ERR_STR            ; rsi = adr of sign
        mov rdi, r8                 ; loading rdi
        rep movsb                   ; print sign str of error in buff
        ret

    STR:
        mov r8, rdi                 ; saving rdi
        mov rdi, [rdx]              ; rdi = adr of str
        call STRLEN                 ; rcx = length of new string

        mov rdi, r8                 ; =
        push rdx                    ; =
        mov rdx, rcx                ; =
        call CHECK_CAP              ; checking fit 
        pop rdx                     ; returning rdx

        mov rsi, [rdx]              ; rsi = adr of str
        mov rdi, r8                 ; loading rdi
        rep movsb
        ret
    
    DEC:
        mov rax, [rdx]              ; rax = number
        lea rsi, [INTBUFF]            ; rsi = int to str buff
        mov rcx, 10                 ; rcx = 10
        call INT_TO_STR             ; retrieving our number
        
        push rdx
        call CHECK_CAP              ; rdi = buffer, rdx = new number of chars
        pop rdx
        
        mov rcx, rdx                ; rcx = rdx
        lea rdx, [INTBUFF + rcx - 1]    ; rdx = INTBUFF
        call REV_PRINT_INT          ; printing in buffer reversed number
        ret

    BIN:
        mov rax, [rdx]              ; rax = number
        lea rsi, [INTBUFF]          ; rsi = int to str buff
        mov cl, 1                   ; byte shift of our binary system
        mov r11, (1 << 1) - 1       ; our mask to get out our chars indexes

        call DB2_TO_STR             ; retrieving our number
        
        push rdx
        call CHECK_CAP              ; rdi = buffer, rdx = new number of chars
        pop rdx

        mov rcx, rdx                ; rcx = rdx
        lea rdx, [INTBUFF + rcx - 1]    ; rdx = INTBUFF
        call REV_PRINT_INT          ; printing in buffer reversed number
        ret

    HEX:
        mov rax, [rdx]              ; rax = buffer
        lea rsi, [INTBUFF]          ; rsi = int to str buff
        mov cl, 4                   ; byte shift of our binary system
        mov r11, (1 << 4) - 1       ; our mask to get out our chars indexes

        call DB2_TO_STR             ; retrieving our number
        
        push rdx
        call CHECK_CAP              ; rdi = buffer, rdx = new number of chars
        pop rdx

        mov rcx, rdx                ; rcx = rdx
        lea rdx, [INTBUFF + rcx - 1]    ; rdx = INTBUFF
        call REV_PRINT_INT          ; printing in buffer reversed number
        ret

    OCT:
        mov rax, [rdx]              ; rax = buffer
        lea rsi, [INTBUFF]          ; rsi = int to str buff
        mov cl, 3                   ; byte shift of our binary system
        mov r11, (1 << 3) - 1       ; our mask to get out our chars indexes

        call DB2_TO_STR             ; retrieving our number
        
        push rdx
        call CHECK_CAP              ; rdi = buffer, rdx = new number of chars
        pop rdx

        mov rcx, rdx                    ; rcx = rdx
        lea rdx, [INTBUFF + rcx - 1]    ; rdx = INTBUFF
        call REV_PRINT_INT              ; printing in buffer reversed number
        ret

;==================================================================================================
;   Checks if buffer can fit chars in it
;
;   ENTRY:  rdi - ending of buffer
;           r12 - start of buffer
;           rdx - new chars number
;   EXIT:   rdi - ending of buffer
;   DESTR:  rax, rsi, rcx
;==================================================================================================
CHECK_CAP:
    mov rsi, r12                    ; rsi = adr buffer
    add rdx, rdi                    ; rdx = new end of buffer
    add rsi, BSIZE                  ; rsi = max capasity adress
    cmp rsi, rdx                    ; CHECK FOR CAPASITY
    mov rsi, r12                    ; backuping rsi to BUFFER_PRINT
    jae .COUNTINUE                  ; if rsi >= rdx, than we don't need new space

    call BUFFER_PRINT
    mov rdi, r12                    ; =
    xor rax, rax                    ; =
    mov rcx, BSIZE                  ; =
    rep stosb                       ; clearing buffer
    mov rdi, r12                    ; end = start

    .COUNTINUE:
        ret

;==================================================================================================
;   Writes full buffer symbol to cmd
;
;   ENTRY:  rsi - adress of buffer
;   EXIT:   -
;   DESTR:  rax, rcx, rdx, rsi, rdi
;==================================================================================================
BUFFER_PRINT:
    mov rdi, rsi                    ; rdi = rsi for scasb
    call STRLEN                     ; counting chars in buffer
    mov rax, 1                      ; system call for write in cmd
    mov rdi, 1                      ; system decriptor
    mov rdx, rcx                    ; length of string
    syscall
    ret

;==================================================================================================
;   Translates integer to string
;
;   ENTRY:  rax - number
;           rsi - number buff
;           rcx - number system
;   EXIT:   rdx - length of number string  
;   DESTR:  rsi, rcx, rax
;==================================================================================================
INT_TO_STR:
    .begin:
    xor rdx, rdx                    ; rdx = 0
    div rcx                         ; resieving new number

    mov dl, [NUMBERLIST + rdx]      ; dl = 'number'
    mov [rsi], dl                   ; writing number in int buffer
    inc rsi                         ; counting length
    cmp rax, 0                      ; =
    ja .begin                       ; if we aren't done we go than  
    
    mov rdx, rsi                    ; =
    sub rdx, INTBUFF                ; rdx = strlen of our number

    ret

;==================================================================================================
;   Translates number(with __divided by 2 number__ system) to string
;
;   ENTRY:  rax - number
;           rsi - number buff
;           cl  - i, where is (2^i - number system)
;           r11 - 2^i - 1, to absorb bits of our number          
;   EXIT:   rdx - length of number string  
;   DESTR:  rsi, rcx, rax, rdx
;==================================================================================================
DB2_TO_STR:
    .begin:
        mov rdx, rax                    ; rdx = rax (our number)
        shr rax, cl                     ; rax = (rax / 2^cl)
        and rdx, r11                    ; rdx = rdx & (1 << cl - 1), absorbing our bits to write
        mov dl, [NUMBERLIST + rdx]      ; converting our number into char
        
        mov [rsi], rdx                  ; writing that char to str 
        inc rsi                         ; updating pointer
        cmp rax, 0h                     ; if we converted all our number, than we exit
    jne .begin

    mov rdx, rsi                        ; saving last symbol + 1 buff pointer
    sub rdx, INTBUFF                    ; rdx = length of number string
    ret

;==================================================================================================
;   Printing our reverced number in string
;
;   ENTRY:  rdx - length of our number in string
;           rdi - our string in which is writing
;   EXIT:   -
;   DESTR:  rax
;==================================================================================================
REV_PRINT_INT:
    .begin:
    mov al, [rdx]   ; =
    mov [rdi], al   ; [rdi + i] = [rdx + n - i]
    inc rdi         ; =
    dec rdx         ; ++i
    loop .begin
    ret

;==================================================================================================
;   Counts chars in string
;
;   ENTRY:  rdi - adress of string
;   EXIT:   rcx - length of string
;   DESTR:  rax, rdi
;==================================================================================================
STRLEN:
    cld                 ; to go in a positive direction
    xor rcx, rcx        ; rcx = 0
    xor rax, rax        ; rax = 0                                
    not rcx             ; rcx = maximum
    repne scasb         ; rcx = maximum - strlen - 1
    not rcx             ; rcx = strlen + 1
    dec rcx             ; rcx = ans 
    ret

section .data

BSIZE           equ 100
INTSIZE         equ 64
BUFFER:         times BSIZE db 0
INTBUFF:        times INTSIZE db 0
NUMBERLIST      db "0123456789ABCDEF", 0

ERR_STR         db "!ERR!", 0
JTABLE  dq 0
                dq BIN
                dq CHAR
                dq DEC
                times ('n' - 'd') dq ERR
                dq OCT
                times ('r' - 'o') dq ERR
                dq STR
                times ('w' - 's') dq ERR
                dq HEX

