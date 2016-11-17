void main()
{
    // Pointer to video memory.
    char *video_memory = (char *) 0xb8000;

    // Put an X in video memory.
    *video_memory = 'X';
}
