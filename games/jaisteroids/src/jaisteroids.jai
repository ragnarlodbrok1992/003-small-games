#import "Basic";
#import "SDL";
#import "String";
#import "Math";

GAME_NAME :: "Jaisteroids";
WINDOW_WIDTH  : s32 = 1024;
WINDOW_HEIGHT : s32 = 768;

RENDERER_FLAGS :: SDL_RendererFlags.ACCELERATED | SDL_RendererFlags.PRESENTVSYNC;

PLAYER_SHIP_SIZE :: 40;
PLAYER_SHIP_COLOR : SDL_Color = .{ r=0xFF, g=0xFF, b=0xFF, a=0xFF };
PLAYER_SHIP_SPEED :: .5;
PLAYER_SHIP_ROTATION_SPEED :: .2;
PLAYER_SHIP_VELOCITY : Vector2 = .{ 0, 0 };

prepare_player_ship :: (player_ship: *SDL_Point, center_x: s32, center_y: s32) {
  player_ship[0].x = center_x;
  player_ship[0].y = center_y - PLAYER_SHIP_SIZE / 2;

  player_ship[1].x = center_x + PLAYER_SHIP_SIZE / 2;
  player_ship[1].y = center_y + PLAYER_SHIP_SIZE / 2;

  player_ship[2].x = center_x;
  player_ship[2].y = center_y;

  player_ship[3].x = center_x - PLAYER_SHIP_SIZE / 2;
  player_ship[3].y = center_y + PLAYER_SHIP_SIZE / 2;

  player_ship[4].x = center_x;
  player_ship[4].y = center_y - PLAYER_SHIP_SIZE / 2;
}

set_render_draw_color :: (renderer: *SDL_Renderer, color: SDL_Color) {
  SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
}

main :: () {
  // Welcome message
  print("Welcome to %!\n", GAME_NAME);
  defer print("Goodbye!\n");

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

  // Create a renderer that will draw to the window
  renderer := SDL_CreateRenderer(window, -1, RENDERER_FLAGS);
  if renderer == null {
      // In the case that the window could not be made...
      print("Could not create renderer: %\n", to_string(SDL_GetError()));
      return;
  }

  PLAYER_SHIP: [5] SDL_Point; // Awesome!
  prepare_player_ship(PLAYER_SHIP.data, WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2);

  frame_start_time : u32;
  frame_end_time : u32;
  frame_duration : float = 0.0;

  exit := false;
  while !exit {
    // Frame counters
    frame_start_time = SDL_GetTicks();

    event : SDL_Event;
    while SDL_PollEvent(*event) {
        if event.type == {
            case SDL_QUIT;
                exit = true;
            case SDL_KEYUP;
                if event.key.keysym.sym == SDLK_ESCAPE exit = true;
        }
    }
    // Simulate game loop
    print("Frame duration: %\n", frame_duration);

    // Clear the screen
    SDL_SetRenderDrawColor(renderer, 0x18, 0x18, 0x18, 0xFF);
    SDL_RenderClear(renderer);

    // Render stuff
    set_render_draw_color(renderer, PLAYER_SHIP_COLOR);
    SDL_RenderDrawLines(renderer, PLAYER_SHIP.data, PLAYER_SHIP.count);

    // Update screen
    SDL_RenderPresent(renderer);

    // End of frame
    frame_end_time = SDL_GetTicks();
    frame_duration = (frame_end_time - frame_start_time) / 1000.0;
  }

  // Close and destroy the window
  SDL_DestroyWindow(window);

  // Clean up
  SDL_Quit();
}
