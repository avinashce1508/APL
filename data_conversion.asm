section .data

msg db  10,"1.Hex to BCD",10
    db "2.BCD to Hex",10
    db "3.Exit",10
len equ $-msg

msg1 db "Enter 4-digit number for hex to bcd:" ,10 , 0
len1 equ $-msg1

msg2 db "Enter 5-digit number for bcd to hex:" , 10 , 0
len2 equ $-msg2

count db 0x00
answer dq 0x00000000


section .bss

choice resb 2
num resb 6
result resb 2
ans resb 3
count1 resb 2
answer1 resb 5
result1 resb 4

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 2
mov rax,0
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .text

global _start
_start:

MENU:	
	print msg,len

	read choice , 2
	
	cmp byte[choice],31H
	je HTB
	cmp byte[choice],32H
	je BTH
	cmp byte[choice],33H
	jae EXIT
	
HTB:
	print msg1,len1		;display msg

	read num ,5	;input num

	mov rcx,04	;ascii to hex
	xor bx,bx
L1:	rol bx,04
	mov al, byte[rsi]
	cmp al,39H
	jbe L2
	sub al,07H
L2:	sub al,30H
	add bl,al
	inc rsi
	loop L1	; ascii to hex

	mov rax,rbx
	mov rbx,0x0A
	xor rdx,rdx
	
L3:	div rbx	
	push dx
	inc byte[count]
	xor rdx,rdx	
	cmp rax,00H
	jnz L3	

L4:	pop dx
	add dx,30H
	mov [result],dx
	print result,2		
	dec byte[count]
	cmp byte[count],00H
	jnz L4	
	
	jmp MENU 


BTH:	
	print msg2,len2		;display msg

	read num , 6	;input num
	
	mov byte[count1],05H
	xor rbx,rbx
	mov rbx,0AH
	mov rsi,num
	xor rax,rax
	
LL1:	xor rdx,rdx
	mul rbx
	mov dl,byte[rsi]
	sub dl,30H
	add rax,rdx
	inc rsi
	dec byte[count1]
	jnz LL1
	
	mov rdx,rax 
	mov dword[result1],00
	call HTA
	print result1,4
	jmp MENU

HTA:	mov byte[count],04H
	mov rdi,result1

L5:	rol dx,04H
	mov al,dl
	and al,0FH
	cmp al,09H
	jbe L6
	add al,07H
L6:	add al,30H
	add byte[rdi],al
	inc rdi
	dec byte[count]
	;cmp byte[count],00H
	jnz L5	;hex to ascii

	ret
	
EXIT:	mov rax,60
	mov rdi,0
	syscall
		
	

