#include "screen.h"
#include "../kernel/low_level.h"

void enable_cursor(unsigned short cursor_start, unsigned short cursor_end)
{
	port_byte_out(0x3D4, 0x0A);
	port_byte_out(0x3D5, (port_byte_in(0x3D5) & 0xC0) | cursor_start);
 
	port_byte_out(0x3D4, 0x0B);
	port_byte_out(0x3D5, (port_byte_in(0x3D5) & 0xE0) | cursor_end);
}

unsigned short get_cursor_position(void)
{
    unsigned short pos = 0;
    outb(0x3D4, 0x0F);
    pos |= inb(0x3D5);
    outb(0x3D4, 0x0E);
    pos |= ((unsigned short)inb(0x3D5)) << 8;
    return pos;
}

void print_char(char a){
    char* video_mem = VIDEO_ADDRESS;
    *(video_mem+5) = a;
}
