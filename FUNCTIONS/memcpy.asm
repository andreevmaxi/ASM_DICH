.model tiny
.data

str1 db 'GOOD'

str2 db 'TEST2'

.code
org 100h

START:
    lea si, str1
    lea di, str2
    mov cx, 4
    
    call MEMCPY
    
    mov ax, 4c00h
    int 21h
    
;===================================================
; Coping first CX bytes of SI to DI
; ENTRY:    di - destonation pointer
;           si - source pointer
;           cx - copy length
; EXIT:     -
; DESTR:    -  
;===================================================
MEMCPY:
    cld
    rep movsb
    
    ret
    
end START