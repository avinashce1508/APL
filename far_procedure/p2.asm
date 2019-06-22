section .data

space db " No of spaces : " 
lspace equ $-space

line db " No of lines : " 
lline equ $-line

char db " Occurence of character : " 
lchar equ $-char

msg db " Enter the character to be searched : "
lmsg equ $-msg

newline db "" , 10
len equ $-newline

s_count db 0x00
l_count db 0x00
c_count db 0x00

section .bss

extern buffer

c resb 1

temp resb 2

%macro print 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

global SPACE , LINE , CHAR

section .text

extern length

SPACE: 
       mov rcx , rax
       mov rsi , buffer 
label: 
       cmp byte[rsi] , 20H
       je l1
       jmp l2
l1: inc byte[s_count]
l2: inc rsi
    loop label
   
    print space , lspace
    mov dl , byte[s_count]
    call HTOA
    print newline , len

    ret
              
LINE:
       mov rcx , qword[length]
       mov rsi , buffer
label1: 
       cmp byte[rsi] , 0AH
       je l3
       jmp l4
l3: inc byte[l_count]
l4: inc rsi
    loop label1
    
    print line , lline
    mov dl , byte[l_count]
    call HTOA
    print newline , len

    ret

CHAR:
     print msg , lmsg
     
     mov rax , 0
     mov rdi , 1 
     mov rsi , c
     mov rdx , 1
     syscall

     mov rcx , qword[length]
     mov rsi , buffer
label3: mov bl , byte[c] 
       cmp byte[rsi] , bl
       je l5
       jmp l6
l5: inc byte[c_count]

l6: inc rsi
    loop label3
 
    print char , lchar 
    mov dl , byte[c_count]
    call HTOA
    print newline , len
    ret
HTOA:

    mov rcx , 02
    mov rdi , temp

up : rol dl , 04
     mov al , dl
     and al , 0Fh
     cmp al , 09h
     jbe next
     add al , 07h
next: add al , 30h
      mov byte[rdi] , al
      inc rdi 
      loop up
    
      print temp , 2
     
ret
