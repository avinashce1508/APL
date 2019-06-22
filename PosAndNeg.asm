;Write X86/64 ALP to count number of positive and negative numbers from the array

section .data    ; section .data is used to declared the initialised variable 

msg db "positive count is :" 
lmsg equ $-msg

msg1 db "negative count is :"
lmsg1 equ $-msg1

newline db "" , 10
len equ $-newline

array dq 1894500000000123h,2008520000000456h,3000078450000789h,8000985100000741h,5002365000000896h 

pcount db 0x00
ncount db 0x00

section .bss  ; bss stands for block started by symbol  and it is used to declared the uninitialised variables

%macro read 2
 mov rax , 0
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

%macro print 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

temp resb 2

section .text
global _start:
_start:

mov rsi , array

mov rcx , 05
label:
mov rax , qword[rsi]
bt rax ,63
jc tag
inc byte[pcount]
jmp l
tag: inc byte[ncount]
l:add rsi , 08
loop label 

print msg , lmsg
mov bl , byte[pcount]
call HTOA

print newline ,len

print msg1 ,lmsg1

mov bl , byte[ncount]
call HTOA


exit:
 mov rax , 60
 mov rdi , 0
 syscall

HTOA:
    mov rcx , 02
    mov rdi , temp
up: rol  bl , 04
    mov al , bl
    and al , 0fh
    cmp al , 09h
    jbe next
    add al , 07h
next: add al , 30h
     mov byte[rdi] , al
     inc rdi
     loop up

     print temp , 2
  ret
