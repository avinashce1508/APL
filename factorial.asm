section .data
 
msg db "Factorial is : " 
lmsg equ $-msg

msg1 db "Factorial is : 0000000000000001 " , 10
lmsg1 equ $-msg1

msg2 db " special characters are not allowded " , 10
lmsg2 equ $-msg2

section .bss

result resb 16

%macro write 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

section .text
global _start:
_start:

pop rbx   ;---- number of arguments
pop rbx   ;---- name of executable file
pop rbx   ;--- number

mov rsi , rbx	
mov rcx , 02
ll1: cmp byte[rbx] , 28h
     jl next
     inc rbx
     loop ll1

call ATOH
mov rax , rbx

cmp rbx , 0
je Display2

call Fact

Display:
       mov rdx , rax
       call HTOA
       write msg , lmsg
       write result , 16
       jmp exit
Display2 :
      write msg1 , lmsg1
      jmp exit
next: write msg2 , lmsg2       
exit:
  mov rax , 60
  mov rdi , 0
  syscall

Fact: cmp rbx , 1
      jne next2
      ret 
next2:Dec rbx
      mul rbx
      call Fact
      ret
ATOH:
  mov rcx , 02
  xor rbx , rbx
tag : rol bl , 04
      mov al , byte[rsi]
      cmp al , 39h
      jbe tag1
      sub al , 07h
tag1: sub al , 30h
      add bl , al
      inc rsi 
      loop tag
      ret

HTOA:
   mov rcx , 16
   mov rdi , result
   
tag2: rol rdx , 04
      mov al , dl
      and al , 0Fh
      cmp al , 09h
      jbe tag3
      add al , 07h
tag3: add al , 30h
      mov byte[rdi] , al
      inc rdi 
      loop tag2
      ret

