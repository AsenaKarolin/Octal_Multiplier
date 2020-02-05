code segment
mov cx,0 ;initializes the values of the registers
mov bx,0
morechar:
mov ah,01h ;reads the first number digit by digit
int 21h
mov dx,0
mov dl,al
mov ax,cx
cmp dl,42d ;checks whether the '*' character is read
je myret
sub dx,48d
mov bp,dx
mov ax,cx
shl bx,1 ;multiplies the current number by 2, 3 times and checks if there is a carry out
shl ax,1
jc carry1
newlabel1:
shl bx,1
shl ax,1
jc carry2
newlabel2:
shl bx,1
shl ax,1
jc carry3
newlabel3:
add ax,bp ; adds the newly read digit to the current number and checks if there is a carry out
jc carry4
newlabel4:
mov cx,ax;
jmp morechar
;-----
carry1: ;handles the cases of carry out
add bx,1d
jmp newlabel1
carry2:
add bx,1d
jmp newlabel2
carry3:
add bx,1d
jmp newlabel3
carry4:
add bx,1d
jmp newlabel4
;-----
myret:
push bx ;pushes the first number into the stack
push cx
mov cx,0 ;initializes the values again
mov bx,0
morechar1: ;reads the second number digit by digit
mov ah,01h
int 21h
mov dx,0
mov dl,al
mov ax,cx
cmp dl,13d ;checks whether the end of the second number is reached
je myret1
sub dx,48d
mov bp,dx
mov ax,cx
shl bx,1 ;multiplies the current number by 2, 3 times and checks if there is a carry out
shl ax,1
jc carry11
newlabel11:
shl bx,1
shl ax,1
jc carry21
newlabel21:
shl bx,1
shl ax,1
jc carry31
newlabel31:
add ax,bp ;adds the newly read digit to the current number and checks if there is a carry out
jc carry41
newlabel41:
mov cx,ax;
jmp morechar1
;-----
carry11: ;handles the cases of carry out
add bx,1d
jmp newlabel11
carry21:
add bx,1d
jmp newlabel21
carry31:
add bx,1d
jmp newlabel31
carry41:
add bx,1d
jmp newlabel41
myret1:
;-----
pop si ;pops the first number from the stack
pop di
;-----
;currently the high part of the first number is held in di
;the low part of the first number is held in si
;the high part of the second number is held in bx
;the low part of the second number is held in cx
;-----
;this part multiplies the two numbers
mov ax,si ;multiplies the low parts of the two numbers
mul cx
push ax ;the least significant 16 bits of the multiplication are pushed to the stack
mov bp,dx
mov ax,bx ;multiplies the low of the first number and the high of the second number
mul si
push bx ;the input numbers are temporarily pushed to the stack to free up some space in the registers
push cx
push di
mov si,0
add ax,bp ;adds the high of the first multiplication is and the low of the second multiplication and checks for carry out
jc random
l1:
mov bp,ax
mov bx,dx
pop di
pop cx
mov ax,cx
mul di ; multiplies the high of the second number and the low of the first number
add ax,bp ;adds the low of this multiplication to the already calculated sum and checks for carry out
jc random1
label1:
pop cx
push ax ;pushes the next 16 bits of the multiplication to the stack
push cx
mov cx,si 
mov si,0
add bx,cx ;adds the carry from the previous additions to the high of the second multiplication and checks for carry out
jc random2
label2:
add bx,dx ;adds the high part of the third multiplication to the sum of the second multiplication and the carry and again checks for carry out
jc random3
label3:
pop ax
mul di ;multiplies the high parts of the input numbers
add bx,ax ;adds the low part of this multiplication to the previously calculated sum and checks for carry out
jc random4
label4:
push bx ;pushes the next 16 bits of the multiplication to the stack
add dx,si ;adds the carry to the high part of the last multiplication
push dx ;pushes the most significant 16 bits of the multiplication to the stack
jmp yazici
;-----
random: ;handles cases of carry
add si,1d
jmp l1
random1:
add si,1d
jmp label1
random2:
add si,1d
jmp label2
random3:
add si,1d
jmp label3
random4:
add si,1d
jmp label4
yazici:
;-----
mov dl,0Ah ;prints a new line
mov ah,02h
int 21h
;-----
;this part converts the multiplication back to octal and pushes each digit of the final output to the stack
pop si ;pops the numbers back to the registers
pop cx
pop bx
pop ax
push 15d ;pushes 15 to the stack as an indicator of the end of the output
mov dx,0 ;divides the number by 8 and pushes the remainder to the stack, this is done 5 times, so 15 bits are handled
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov bp,bx ;the remaining bit from the first number is concatenated to the second number by shifting the number
shl bp,1
add bp,ax
mov ax,bp
mov dx,0 ;divides the number by 8 and pushes the remainder to the stack, this is done 5 times, so 15 bits are handled
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
shr bx,14d
mov bp,cx
shl bp,2 ;the remaining 2 bits from the second number are concatenated to the third number by shifting the number
add bp,bx
mov ax,bp
mov dx,0 ;divides the number by 8 and pushes the remainder to the stack, this is done 5 times, so 15 bits are handled
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
shr cx,13d
mov bp,si
shl bp,3 ;the remaining 3 bits from the third number are concatenated to the fourth number by shifting the number
add bp,cx
mov ax,bp
mov dx,0 ;divides the number by 8 and pushes the remainder to the stack, this is done 5 times, so 15 bits are handled
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
shr si,12d ;the remaining four bits are handled lastly
mov ax,si
mov dx,0
mov di,8
div di
push dx
mov dx,0
mov di,8
div di
push dx
;-----
;this part prints the octal digits in the stack
initial:
mov cx,0 ;the first 0s are not printed
pop ax
cmp ax,0
jne control
jmp initial
print: ;prints the octal digit
add cx,1 ;increments the counter cx which shows how many digits have been printed
mov dl,al
add dl,30h
mov ah,02h
int 21h
pop ax
control: ;checks if the end of the stack is reached
cmp ax,15d
jne print
jmp exit
exit:
cmp cx,0 ;checks if the output consisted of all 0s, if so prints 0
jne final
mov dl,30h
mov ah,02h
int 21h
final:
int 20h
code ends