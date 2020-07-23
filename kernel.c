void main() {
    // this points to the memory that holds the character that is at the top left of the screen
    char* video_memory = (char*) 0xb8000;
    // Change the character at the top left of the screen
    *video_memory = 'X';
}
