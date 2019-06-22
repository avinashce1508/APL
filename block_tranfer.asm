section .data

msg db " : " 
lmsg equ $-msg

msg1 db "" , 10
lmsg1 equ $-msg1

msg2 db " Original array is :" , 10
lmsg2 equ $-msg2

menu  db "menu" ,10
      db "1. intial array" ,10
      db "2. non overlapped block transfer " , 10
      db "3. overlapped block transfer " ,10
      db "4. non overlapped block transfer with string" ,10
      db "5. overlapped block transfer with string " ,10
      db "6. exit",10
      db "Enter your choice",10
lmenu equ $-menu


array dq 1894500000000123h,2008520000000456h,3000078450000789h,8000985100000741h,5002365000000896h , 000000000000h , 000000000000h , 00000000h

section .bss

%macro print 2
 mov rax , 1  ;  write system call
 mov rdi , 1  ;  write to stdout
 mov rsi , %1
 mov rdx , %2
 syscall       ; invoked kernel to do something 
%endmacro

%macro scan 2
 mov rax , 0
 mov rdi , 1   ; read from stdout
 mov rsi , %1
 mov rdx , %2
syscall
%endmacro

%macro exit 0
 mov rax , 60  ; ----- exit system call
 mov rdi , 0
 syscall
%endmacro

temp resb 16
choice resb 2

section .text

global _start:
_start:
    
displaymenu:

  print menu , lmenu
  scan choice , 2

  cmp byte[choice] , 31h
  je original

  cmp byte[choice] , 32h
  je NonOverlapWithoutString

  cmp byte[choice] , 33h
  je OverlapWithoutString

  cmp byte[choice] , 34h
  je NonOverlapWithString

  cmp byte[choice] , 35h
  je OverlapWithString

  cmp byte[choice] , 36h
  jae exit

original:

 print msg2 , lmsg2
 xor rsi , rsi 
 mov rsi , array
 mov rcx , 05
 call display
 jmp displaymenu
 
NonOverlapWithoutString:

xor rsi , rsi
mov rsi , array
mov rdi , array+ 2000
mov rcx , 05

call dataTransfer

mov rsi , array+2000
mov rcx , 05
call display

jmp displaymenu

OverlapWithoutString:

xor rsi , rsi
mov rsi , array
mov rdi , array+ 2000
mov rcx , 05

call dataTransfer

xor rsi , rsi
mov rsi , array+2000
mov rdi , array+16
mov rcx , 05

call dataTransfer

xor rsi , rsi 
mov rsi , array
mov rcx , 07

call display

jmp displaymenu

NonOverlapWithString:

xor rsi , rsi
mov rsi , array
mov rdi , array+ 1000
mov rcx , 05

repnz movsq

xor rsi , rsi
mov rsi , array+1000
mov rcx , 05
call display

jmp displaymenu

OverlapWithString:

xor rsi , rsi
mov rsi , array
mov rdi , array + 1000
mov rcx , 05

repnz movsq

xor rsi , rsi
mov rsi , array+1000
mov rdi , array+16
mov rcx , 05


tag3: movsq
    loop tag3

xor rsi , rsi 
mov rsi , array
mov rcx , 07

call display

 jmp displaymenu 

 exit  ; exit system call

dataTransfer:
label:  mov rax , qword[rsi]
        mov qword[rdi] , rax
        add rsi , 08
        add rdi , 08
        loop label
ret
display:
    mov rdx , rsi
    push rsi
    push rcx
    call htoa
   
    print msg , lmsg

    pop rcx 
    pop rsi 
   
    mov rdx , qword[rsi]
    push rsi
    push rcx
    call htoa

    print msg1 , lmsg1

    pop rcx
    pop rsi
   
    add rsi , 08
    loop display  
     
ret

htoa:
  xor rdi , rdi
  mov rcx , 016
  mov rdi , temp

up : rol rdx , 04
     mov al , dl
     and al , 0fh
     cmp al , 09h
     jbe down
     add al , 07h
down: add al , 30h
      mov byte[rdi] , al
      inc rdi 
      loop up
     
      print temp , 16
ret
