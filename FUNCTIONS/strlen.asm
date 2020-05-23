.model tiny
.data

str1 db 'GOOD_DAY'

.code
org 100h

START:
    lea di, str1
    
    call STRLEN
    
    mov ax, 4c00h
    int 21h
     
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