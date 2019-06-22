;Write X86 program to sort the list of integers in ascending/descending order. Read the input from the text file and write the sorted data back to
;the same text file using bubble sort
;

section .data
menu db " ---------------------------- " , 10
     db "            MENU              " , 10
     db " ---------------------------- " , 10
     db " 1) Ascending order " , 10
     db " 2) Decending order " , 10
     db " 3) Exit " , 10
     db "    Enter your choice " , 10
lmenu equ $-menu

msg db " File open successfully " , 10 
lmsg equ $-msg

msg1 db " Error in Opening file " , 10
lmsg1 equ $-msg1

msg2 db " Ascending Order is : " 
lmsg2 equ $-msg2

msg3 db " Decending Order is : " 
lmsg3 equ $-msg3

msg4 db " Original Array is : " 
lmsg4 equ $-msg4

msg5 db " " , 10
lmsg5 equ $-msg5

fname db 'sort.txt' , 0

;-------------- end of section.data -----------------
section .bss

buffer resb 10
choice resb 2
fd resq 1
bufferlen resq 1
count resb 1
pass resb 1
flag resb 1

%macro write 2   ; ----- macro for printing msg
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall 
%endmacro

%macro read 2  ;----- macro for reading input from user
 mov rax , 0
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall 
%endmacro

;---------------------- end of section.bss ---------     

section .text
 global _start:
 _start:

 ;-------- opening a file ------------

  mov rax , 2  ; --- opening a file
  mov rdi , fname   ; --- name of file
  mov rsi , 2    ; ---- read and write access
  mov rdx , 0777  ;---- all permissions
  syscall

  mov qword[fd] , rax
  BT rax , 63
  jc tag
  write msg , lmsg
  jmp skip
tag : write msg1 , lmsg1

skip :
    
    mov rax , 0   ; ----- reading the file
    mov rdi , [fd]  ; ---- file descriptor
    mov rsi , buffer
    mov rdx , 10
    syscall 

    mov qword[bufferlen] , rax 
    write msg4 , lmsg4
    write buffer , [bufferlen]

mov byte[flag] , 0
display :  write menu , lmenu
           read choice , 2

           cmp byte[choice] , 31h
           je ascending
           cmp byte[choice] , 32h
           je sorting
           cmp byte[choice] , 33h
           jae exit

ascending :
   mov byte[flag] ,  1

sorting:
   mov byte[count] , 05

tag1: mov rsi , buffer
      mov rdi , buffer + 2
      mov byte[pass] , 04
label :cmp byte[flag] , 1
       je label5 
       jmp label3
label5: mov al , byte[rsi]
        cmp al , byte[rdi]
        ja label2
        jmp label4
label3:
        mov al , byte[rsi]
        cmp al , byte[rdi]
        jbe label2
 
label4: add rsi , 02
        add rdi , 02
        dec byte[pass]
        jnz label
        jmp tag2
label2 : mov al , byte[rsi]
         mov dl , byte[rdi]
         mov byte[rsi] , dl
         mov byte[rdi] , al
         add rsi , 02
         add rdi , 02
         dec byte[pass]
         jnz label 

tag2 :           
      dec byte[count]
      jnz tag1

      cmp byte[flag] , 1
      je tag3
      jmp tag4
      ;------ writing the msg to file 
tag3:  write msg2 , lmsg2
      write buffer , bufferlen

      mov rax , 1
      mov rdi , [fd]
      mov rsi , msg2
      mov rdx , lmsg2
      syscall
      ; -------- writing the sorted array to file
      mov rax , 1
      mov rdi , [fd]
      mov rsi , buffer
      mov rdx , [bufferlen]
      syscall

      mov byte[flag] , 0
jmp display      

tag4:  write msg3 , lmsg3
      write buffer , bufferlen

      mov rax , 1
      mov rdi , [fd]
      mov rsi , msg3
      mov rdx , lmsg3
      syscall
      ; -------- writing the sorted array to file
      mov rax , 1
      mov rdi , [fd]
      mov rsi , buffer
      mov rdx , [bufferlen]
      syscall
jmp display  
;--------------- end of decending method --------
exit:
   mov rax , 60
   mov rdi , 0
   syscall



   
      
