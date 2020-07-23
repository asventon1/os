
print_hex: ; Function that prints a single 16 bit number from register dx as hex
    pusha
    mov cx, dx ; saves the original value of dx to cx
    
    and dx, 0x000f ; gets only the last diget of the number.
                   ; If if the number in dx was 45da dx would be 000a
    mov bx, HEX_CHARS ; HEX_CHARS has the value 0123456789abcdefg so when we add dx to bx it will move
                      ; bx to that numbers corresponding character.
    add bx, dx
    mov bl, byte [bx] ; gets the character that bx ended up on and puts it in bl.
    mov byte [HEX_OUT+5], bl ; moves bl to the last character of HEX_OUT
                             ; which will be printed at the end of the function.

    mov dx, cx ; reload to original value of dx since it got changes in the last part of the function.
    and dx, 0x00f0 ; gets the second to last diget of the number
    shr dx, 4 ; makes the second the last diget the last diget.
              ; if the the original value of dx 45da then the and instruction would make it 00d0.
              ; then the shr or shift right instruction would change dx to 000d.
    mov bx, HEX_CHARS ; same as above 
    add bx, dx
    mov bl, byte [bx]
    mov byte [HEX_OUT+4], bl ; puts bl into the second to last character instead of the last
    
    mov dx, cx ; Does all the same things with the third to last diget
    and dx, 0x0f00
    shr dx, 8
    mov bx, HEX_CHARS
    add bx, dx
    mov bl, byte [bx]
    mov byte [HEX_OUT+3], bl

    mov dx, cx ; Does all the same things with the forth to last diget
    and dx, 0xf000
    shr dx, 12
    mov bx, HEX_CHARS
    add bx, dx
    mov bl, byte [bx]
    mov byte [HEX_OUT+2], bl

    mov bx, HEX_OUT ; Sets the HEX_OUT string we have bean chainging to be printed
    call println_string ; calls println_string to print the string
    popa ; resets the registers
    ret ; returns
    

println_string: ; Function that prints a null terminated string from register bx with a newline after
    pusha ; Pushes registers to stack to save them
    call print_string ; Calls print_string to print the string in bx
    mov ah, 0x0e ; Tells BIOS to print character with next interrupt
    mov al, 0xa ; Sets character to be printed to newline
    int 0x10 ; Tells BIOS to print
    mov al, 0xd ; The newline character goes down one line but not back to the start of the line.
                ; This is the cartrage return character,
                ; and it sends the cursor the the begining if the line
    int 0x10 ; Print
    popa ; pop the registers off the stack
    ret ; return

print_string: ; Function that prints a null terminated string from register bx
    pusha ; Pushes registers to stack to save them
print_string_loop: ; Loop that goes over every character and prints it unilt it reaches a null char
    mov ah, 0x0e ; Tells BIOS to print character
    cmp byte [bx], 0 ; Checks if the current character is null
    je print_string_end ; Exits the loop if it is
    mov al, [bx] ; Moves character to al where the BIOS will print it
    int 0x10 ; Tells the BIOS to print the character
    inc bx ; Changes the currents character to the next one in the string
    jmp print_string_loop ; Repeat the loop with the next character
print_string_end: ; Loop exit
    popa ; Pops the register back off the stack to reset them
    ret ; Returns from the function
    
HEX_CHARS: db '0123456789abcdefg'
HEX_OUT: db '0x0000', 0
