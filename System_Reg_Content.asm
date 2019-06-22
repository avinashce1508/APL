; write the alp to switch from real mode to protedted mode and display the value of gdtr , ldtr , idtr ,tr and msw registers

;--- we are displaying only 16 bits of msw because msw is concept of 8086 and in 386 it is renamed as CR0 with 32  bit field

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

menu db "*********************************" , 10
     db "            MENU                 " , 10      
     db "*********************************" , 10
     db "1 : To check whether system is in real mode or protected mode " ,10
     db "2 : To display the value of GDTR " , 10
     db "3 : To display the value of LDTR " , 10
     db "4 : To display the value of IDTR " , 10
     db "5 : To display the value of TR   " , 10
     db "6 : To display the value of MSW  " , 10
     db "7 : Exit " , 10
     db "  Enter your choice" , 10 
len equ $-menu

msg1 db "system is in protected mode " , 10
len1 equ $-msg1

msg2 db "system is in real mode " , 10
len2 equ $-msg2

msg3 db "Base address is : " 
len3 equ $-msg3

msg4 db "Limit is : "
len4 equ $-msg4 
 
msg5 db "" , 10
len5 equ $-msg5

msg6 db "GDTR : " 
len6 equ $-msg6

msg7 db "IDTR : "  
len7 equ $-msg7

msg8 db "LDTR : " 
len8 equ $-msg8

msg9 db "TR : " 
len9 equ $-msg9

msg10 db "MSW : " 
len10 equ $-msg10
   

;--------------------- end of section .data --------------
section .bss

 choice resb 2
 result resb 4
 gmem resb 6
 imem resb 6
 lmem resb 2
 tr resb 2
 msw resb 4
;--------------------- end of section .bss -----------------

section .text
global _start
_start:

display :  

                print menu , len
 		read choice ,2
 
 		cmp byte[choice] , 31h
 		je label1
 
 		cmp byte[choice] , 32h
 		je label2
 
 		cmp byte[choice] , 33h
 		je label3
 
 		cmp byte[choice] , 34h
 		je label4
 
 		cmp byte[choice] , 35h
 		je label5
 
 		cmp byte[choice] , 36h
 		je label6
 		
 		cmp byte[choice] , 37h
 		je Exit

label1:
       SMSW ebx
       bt ebx , 0
       jc tag
       print msg2 , len2
       jmp display
   tag: print msg1 , len1     
jmp display
;---------------- end of label1 ---------------

label2:
       
       print msg6 , len6
       SGDT [gmem] 
       print msg3 , len3
       mov dx , word[gmem + 4]
       call HTOA
       mov dx , word[gmem + 2] 
       call HTOA
       print msg4 , len4
       mov dx , word[gmem]
       call HTOA   
       print msg5 , len5
       
jmp display
;---------------- end of label2 --------------
 
label3:
       print msg8 , len8
       SLDT [lmem];
     
       mov dx , word[lmem]
       call HTOA 
      print msg5 , len5
jmp display
;---------------- end of label3 --------------
 
label4:
       print msg7 , len7
       SIDT [imem];
       print msg3 , len3
       mov dx , word[imem + 4]
       call HTOA
       mov dx , word[imem + 2] 
       call HTOA
       print msg4 , len4
       mov dx , word[imem]
       call HTOA
       print msg5 , len5 
jmp display
;---------------- end of label4 --------------
 
label5:
       print msg9 , len9
       STR [tr]
     
       mov dx , word[tr]
       call HTOA 
       print msg5 , len5
jmp display
;---------------- end of label5 --------------
  
label6:
       print msg10, len10
       SMSW [msw];
     
       mov dx , word[msw]
       call HTOA
       print msg5 , len5
jmp display
;---------------- end of label6 --------------
  
Exit:
mov rax , 60
mov rdi , 0
syscall

HTOA:
mov rdi , result
mov rcx , 04

l1 : rol dx , 04
     mov al , dl
     and al , 0fh
     cmp al , 09h
     jbe l2
     add al , 07h
l2 : add al , 30h
     mov byte[rdi] , al
     inc rdi      
     loop l1
     print result , 6
     
     ret 
