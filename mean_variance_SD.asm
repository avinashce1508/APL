
section .data

msg1 db "." , 0
lmsg1 equ $-msg1

msg2 db "Mean is               : " 
lmsg2 equ $-msg2

msg3 db "Varience is           : "  
lmsg3 equ $-msg3

msg4 db "Standerd Deviation is : "
lmsg4 equ $-msg4

msg5 db " " , 10
lmsg5 equ $-msg5

array dd 80.12 , 10.12 , 100.96 ,50.08 , 60.09 

arraycount : dw 5

dec : dw 100


section .bss


%macro write 2
 mov rax , 1
 mov rdi , 1
 mov rsi , %1
 mov rdx , %2
 syscall
%endmacro

resultbuffer rest 1
printbuffer resb 2
temp resb 2
mean resd 1
varience resd 1
sdeviation resd 1


section .text
 global _start:
 _start:

;================= mean ============  
  mov rcx , 05
  mov rsi , array
  finit   ;  initialise 80387 ndp
  fldz

tag: fadd dword[rsi]
     add rsi , 04
     loop tag

     fidiv word[arraycount]
     fst dword[mean]
     write msg2 , lmsg2
     call display
     write msg5 , lmsg5
;================== varience =======      
 
 write msg3 , lmsg3
 fldz  ; initialise 80387
 mov rcx , 05
 mov rsi , array

vup : fldz 
      fadd dword[rsi]
      fsub dword[mean]
      fmul ST0 
      fadd     ; add st0 and st1 and stored at st1 and stack top becomes st1
      add rsi , 4
      loop vup
     
      fidiv word[arraycount]
      fst dword[varience]
      call display
      write msg5 , lmsg5

;======= standerd deviation =====

 write msg4 , lmsg4
  fldz
  fld dword[varience]
  fsqrt
  fst dword[sdeviation]
  call display
  write msg5 , lmsg5
;---------------------------     
exit: mov rax , 60
      mov rdi , 0
      syscall

display: fimul word[dec]
         fbstp [resultbuffer]
         xor rcx , rcx
         mov cx , 09
         mov rsi , resultbuffer + 09
  tag2:  mov dl , byte[rsi]
         push rsi
         push rcx 
         call HTOA
         pop rcx 
         pop rsi
         dec rsi
         loop tag2

        write msg1 , lmsg1  ; display dot (.) 
        
        mov rsi, resultbuffer
        mov dl , byte[rsi]
        call HTOA
   ret

HTOA:
      mov rcx , 02
      mov rdi , temp
 label: rol dl , 04
        mov al , dl
        and al , 0Fh
        cmp al , 09h
        jbe label1
        add al , 07h
 label1: add al , 30h
        mov byte[rdi] , al
        inc rdi
        loop label
 
        write temp , 2     
     ret      
