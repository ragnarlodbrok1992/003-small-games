#import "Basic";
#import "SDL";
#import "String";

GAME_NAME :: "Jaisteroids";
WINDOW_WIDTH  : s32 = 1024;
WINDOW_HEIGHT : s32 = 768;

main :: () {
  // Initialize SDL
  SDL_Init(SDL_INIT_VIDEO);
  

  // Create an application window with the following settings:
  window := SDL_CreateWindow(GAME_NAME,
    SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
    WINDOW_WIDTH, WINDOW_HEIGHT,
    SDL_WINDOW_OPENGL|SDL_WINDOW_SHOWN);

  // Check that the window was successfully created
  if window == null {
      // In the case that the window could not be made...
      print("Could not create window: %\n", to_string(SDL_GetError()));
      return;
  }

  exit := false;
  while !exit {
      event : SDL_Event;
      while SDL_PollEvent(*event) {
          if event.type == {
              case SDL_QUIT;
                  exit = true;
              case SDL_KEYUP;
                  if event.key.keysym.sym == SDLK_ESCAPE exit = true;
          }
      }
  }

  // Close and destroy the window
  SDL_DestroyWindow(window);

  // Clean up
  SDL_Quit();
}
