
section .data

msg db " File Open Successfully " , 10
lmsg equ $-msg

msg1 db " Error in Opening file " , 10
lmsg1 equ $-msg1



section .bss


%macro write 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro
 
fname1 resq 1
fname2 resq 1
fd1 resq 1
fd2 resq 1
temp resb 50
length resq 1

section .text
 global _start:
 _start:


  pop rbx 
  pop rbx 
  pop rbx

  cmp byte[rbx] , 43h
  je Copy
  cmp byte[rbx] , 44h
  je Delete

  jmp Type
Copy :
       pop rbx
       mov rsi , fname1
   tag1: mov al , byte[rbx]
         mov byte[rsi] , al
         inc rsi
         inc rbx
         cmp byte[rbx] , 0
         jnz tag1

       pop rbx
       mov rsi , fname2
   tag2: mov al , byte[rbx]
         mov byte[rsi] , al
         inc rsi
         inc rbx
         cmp byte[rbx] , 0
         jnz tag2


      ;------ opening the file ----
       mov rax , 2
       mov rdi , fname1
       mov rsi , 2
       mov rdx , 777
       syscall
      
       mov qword[fd1] , rax
        BT rax , 63
       jc label
       write msg , lmsg
       jmp label1
   label : write msg1 , lmsg1
         jmp exit
       ;------ reading the file --- 
  label1:
       mov rax , 0
       mov rdi , [fd1]
       mov rsi , temp
       mov rdx , 50
       syscall
       
       mov qword[length] , rax
        
       ;------ opening the file ----
       mov rax , 2
       mov rdi , fname2
       mov rsi , 2
       mov rdx , 0777
       syscall
    
       mov qword[fd2] , rax
        BT rax , 63
       jc label3
       write msg , lmsg
       jmp label4
  label3 : write msg1 , lmsg1
         jmp exit 

       ; ---- writing to file with name fname2
  label4:
       mov rax , 1
       mov rdi , [fd2]
       mov rsi , temp
       mov rdx , [length]
       syscall
    
   ;----- closing both files
      mov rax , 3
      mov rdi , [fd1]
      syscall
      
      mov rax , 3
      mov rdi , [fd2]
      syscall
    jmp exit

Delete :
     pop rbx
 
     mov rsi , fname1
   tag4: mov al , byte[rbx]
         mov byte[rsi] , al
         inc rsi
         inc rbx
         cmp byte[rbx] , 0
         jnz tag4
   ;---------- delete call
    mov rax , 87
    mov rdi , fname1
    syscall
    jmp exit

Type:
         pop rbx
 
     mov rsi , fname1
   tag5: mov al , byte[rbx]
         mov byte[rsi] , al
         inc rsi
         inc rbx
         cmp byte[rbx] , 0
         jnz tag5

       ;------ opening the file ----
       mov rax , 2
       mov rdi , fname1
       mov rsi , 2
       mov rdx , 0777
       syscall
       mov qword[fd1] , rax
       
       BT rax , 63
       jc next
       write msg , lmsg
       jmp next1
  next : write msg1 , lmsg1
         jmp exit
       ;------ reading the file --- 
 next1: mov rax , 0
       mov rdi , [fd1]
       mov rsi , temp
       mov rdx , 50
       syscall
       
       mov qword[length] , rax
        
       write temp , [length]
     
      ;------ close the file
       mov rax , 3
       mov rdi , [fd1]
       syscall


exit: mov rax , 60
      mov rdi , 0
      syscall

