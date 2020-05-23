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
    
    call STRCPY
    
    mov ax, 4c00h
    int 21h
  
;===================================================
; Coping first (length) bytes of SI to DI
; ENTRY:    di - destonation pointer
;           si - source pointer
; EXIT:     -
; DESTR:    -  
;===================================================
STRCPY:
    push di
    call STRLEN
    pop di
    
    call MEMCPY
    
    ret
    
        
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
        
;==================================================================================================
;   Counts chars in string
;
;   ENTRY:  di - adress of string
;   EXIT:   cx - length of string
;   DESTR:  ah, di
;==================================================================================================
STRLEN:
    cld               
    xor cx, cx        
    xor al, al                                     
    not cx           
    repne scasb      
    not cx            
    dec cx           
    ret    
         
end START