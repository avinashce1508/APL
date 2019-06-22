%macro print 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

%macro read 2
 mov rax , 0
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro  
section .data
menu db "==========================" , 10
     db "           menu           " , 10
     db "==========================" , 10
     db "1 : multiplication by successive addition " , 10
     db "2 : multiplication by Add and shift Algo " , 10
     db "3 : Exit " , 10
len equ $-menu

msg1 db "Enter the multiplicand " ,10
len1 equ $-msg1

msg2 db "Enter the multiplier " , 10
len2 equ $-msg2

msg3 db "Multiplication is : "
len3 equ $-msg3

msg4 db " " ,10
len4 equ $-msg4

section .bss

multiplicand resb 3
result resb 5
num resb 3
choice resb 2

section .text
global _start:
_start:

display : print menu , len 
          read  choice , 2
          
          cmp byte[choice] , 31h
          je succ_add
          
          cmp byte[choice] , 32h
          je Add_and_shift
          
          cmp byte[choice] , 33h
          jae exit     

succ_add :  print msg1 ,  len1
            read num , 3
            call ATOH
            mov byte[multiplicand] , bl
                          
            print msg2 , len2
            read num, 3
            call ATOH
            xor rcx , rcx 
            mov cl , bl  
                   
           
            xor rbx , rbx 
            mov bl  , byte[multiplicand]
            xor rax , rax

     lable:  cmp cl , 0
             je newlabel
             add rax , rbx
             loop lable    
       
    newlabel:xor rdx , rdx 
            mov rdx , rax
            call HTOA
          
           print result , 5  
           print msg4 , len4 
 jmp display        
 ;-----------------endof successive addition --------------           
Add_and_shift :
            print msg1 ,  len1
            read num , 3
            call ATOH
            mov byte[multiplicand] , bl
                          
            print msg2 , len2
            read num, 3
            call ATOH
            xor rcx , rcx 
            mov cl , 08
            xor rax , rax
            mov dl , byte[multiplicand]
     tag:   shr bx , 01
            jc lable1
            shl dx , 01
            jmp ll1
   lable1 : add rax , rdx
            shl dx , 01

   ll1:    loop tag
            
      mov dx , ax
      call HTOA
      print result , 5
      print msg4 , len4
jmp display
exit :
    mov rax , 60
    mov rdi , 0
    syscall
    
ATOH : 
     mov rcx , 02h
     mov rsi ,  num
     xor rbx  , rbx
  
  l1: rol bl , 04
      mov al,byte[rsi]
      cmp al , 39h
      jbe l2
      
      sub al, 07h
      
  l2: sub al, 30h
      add bl , al
      inc rsi
      loop l1    
      
     ret
    
    
HTOA:     	
  mov rcx , 04
  mov rdi , result
  
  l5: rol dx , 04
      mov ax , dx
      and ax , 0fh 
      cmp ax , 09h
      jbe l6
      add ax , 07h
  l6: add ax , 30h
       mov byte[rdi] , al
       inc rdi
       loop l5
    
   ret                  
                       
