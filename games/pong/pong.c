#include <stdio.h>

#define SDL_MAIN_HANDLED
#include <SDL.h>
#include <stdbool.h>

// Const stuff
const int WINDOW_WIDTH = 1280;
const int WINDOW_HEIGHT = 720;
bool ENGINE_RUNNING = true;
SDL_Window *window = NULL;
SDL_Renderer *renderer = NULL;

int main(void)
{
  printf("Pong Game in SDL.\n");

  // Initialize SDL
  if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
  {
      printf("SDL_Init Error: %s\n", SDL_GetError());
      return 1;
  }

  // Create a window
  window = SDL_CreateWindow("Pong Game",
                            SDL_WINDOWPOS_UNDEFINED,
                            SDL_WINDOWPOS_UNDEFINED,
                            WINDOW_WIDTH,
                            WINDOW_HEIGHT,
                            SDL_WINDOW_SHOWN);
  if (window == NULL)
  {
      printf("SDL_CreateWindow Error: %s\n", SDL_GetError());
      SDL_Quit();
      return 1;
  }

  // Create a renderer
  renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (renderer == NULL)
  {
      SDL_DestroyWindow(window);
      printf("SDL_CreateRenderer Error: %s\n", SDL_GetError());
      SDL_Quit();
      return 1;
  }

  // Main game loop
  while (ENGINE_RUNNING)
  {
    SDL_Event event;
    while (SDL_PollEvent(&event))
    {
      // Internal events
      if (event.type == SDL_QUIT)
      {
        ENGINE_RUNNING = false;
      }
      // Keypresses
      if (event.type == SDL_KEYDOWN)
      {
        switch (event.key.keysym.sym)
        {
          case SDLK_ESCAPE:
            ENGINE_RUNNING = false;
            break;
          default:
            break;
        }
      }
    }

    // Clear the screen
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);

    // Draw the screen
    SDL_RenderPresent(renderer);
  }


  printf("All went well - goodbye!\n");
  return 0;
}

