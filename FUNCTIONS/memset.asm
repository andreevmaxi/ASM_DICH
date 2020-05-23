.model tiny
.data

str1 db 'GOOD_DAY'

.code
org 100h

START:
    lea di, str1
    mov cx, 8
    mov al, 'A'
    
    call MEMCMP
    
    mov ax, 4c00h
    int 21h
    
;===================================================
; Writing first CX bytes by the AL
; ENTRY:    di - destonation pointer
;           al - char
;           cx - copy length
; EXIT:     -
; DESTR:    -  
;===================================================
MEMCMP:
    cld
    rep stosb
    
    ret
    
end START