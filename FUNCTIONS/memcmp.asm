.model tiny
.data

str1 db 'TEST'

str2 db 'TEST2'

.code
org 100h

START:
    lea si, str1
    lea di, str2
    mov cx, 5
    
    call MEMCMP
    
    mov ax, 4c00h
    int 21h
    
;===================================================
; Comparing first CX numbers of strings
; ENTRY:    si - pointer to 1st string
;           di - pointer to 2nd string
;           cx - str comparing length
; EXIT:     ah - 1 -> 1st bigger
;                0 -> equal
;                -1-> 2st bigger
; DESTR:    -  
;===================================================
MEMCMP:
    cld

    repe cmpsb
    jl  FIRST
    jg  SECOND
    jmp EQUAL
    
    FIRST:
        mov al, -1
        jmp EXIT
   
    SECOND:    
        mov al, 1
        jmp EXIT
    
    EQUAL:
        mov al, 0 
        
    EXIT:
        ret
    
end START