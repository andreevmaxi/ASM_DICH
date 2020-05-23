section .text

global _start

extern PRINTF

_start: 
;-----------------------------------------------------------------------------------
; TEST_1:
    mov rbp, rsp                            
    mov rsi, TEST_1                  
    push 256                         ; 100h
    push 1                           ; 1d 
    push TEST_1.1_ARG                 
    call PRINTF                       
    add rsp, 24  
    mov rsi, OK_STR 
    push 1
    call PRINTF
    add rsp, 8

;-----------------------------------------------------------------------------------
; TEST_2:
    mov rbp, rsp                            
    mov rsi, TEST_2                
    push 53  
    push 6                         
    push 7                          
    push TEST_2.2_ARG
    push TEST_2.1_ARG                 
    call PRINTF                       
    add rsp, 40      
    mov rsi, OK_STR 
    push 2
    call PRINTF
    add rsp, 8                     

;-----------------------------------------------------------------------------------
; TEST_3:
    mov rbp, rsp                            
    mov rsi, TEST_3  
    push TEST_3.1_ARG              
    push 158                            ; 9eH                         
    call PRINTF                       
    add rsp, 16  
    mov rsi, OK_STR 
    push 3
    call PRINTF
    add rsp, 8

;-----------------------------------------------------------------------------------
; TEST_4:
    mov rbp, rsp                            
    mov rsi, TEST_4             
    push 1802                            ; 3412                         
    call PRINTF                       
    add rsp, 8  
    mov rsi, OK_STR 
    push 4
    call PRINTF
    add rsp, 8

;-----------------------------------------------------------------------------------
; TEST_5:
    mov rbp, rsp                            
    mov rsi, TEST_5             
    push 't'                                                   
    call PRINTF                       
    add rsp, 8 
    mov rsi, OK_STR 
    push 5
    call PRINTF
    add rsp, 8

;-----------------------------------------------------------------------------------
; TESTS ENDED:

    mov rax, 60d                        ; exit system call
    xor rdi, rdi                        ; 0 exit code
    syscall                             ; shutting down the program


section .data

OK_STR            db "Test#%d - passed", 10d, 13d, 10d, 13d, 0h

TEST_1            db "Korob.%s is the %dst of the coolest domens in %x%% counties!", 10d, 13d, 0h      
TEST_1.1_ARG      db "com", 0h
TEST_2            db "%s%s %d o'clock, %d:%d, if we want to be more concrete", 10d, 13d, 0h      
TEST_2.1_ARG      db "I just want to sleep", 0h
TEST_2.2_ARG      db ", no, really, it's", 0h
TEST_3            db "%b - is the best%sin DOS", 10d, 13d, 0h
TEST_3.1_ARG      db " color ", 0h
TEST_4            db "Just good test for %%o: %o", 10d, 13d,0h
TEST_5            db "Just %cest for error %j", 10d, 13d, 0h