#include <stdio.h>

#define SDL_MAIN_HANDLED
#include <SDL.h>

int main(void)
{
    printf("Pong Game in SDL.\n");

    // Initialize SDL
    if (SDL_Init(SDL_INIT_VIDEO) != 0)
    {
        printf("SDL_Init Error: %s\n", SDL_GetError());
        return 1;
    }

    printf("All went well - goodbye!\n");
    return 0;
}

