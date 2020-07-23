#ifndef SCREEN_H
#define SCREEN_H

#define  VIDEO_ADDRESS 0xb8000
#define  MAX_ROWS  25
#define  MAX_COLS  80
//  Attribute  byte  for  our  default  colour  scheme.
#define  WHITE_ON_BLACK 0x0f
//  Screen  device I/O ports
#define  REG_SCREEN_CTRL 0x3D4
#define  REG_SCREEN_DATA 0x3D5

void print_char(char a);
void enable_cursor(unsigned short cursor_start, unsigned short cursor_end);
unsigned short get_cursor_position(void);

#endif
