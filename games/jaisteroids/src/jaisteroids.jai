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
PLAYER_SHIP_CENTER : Vector2;
// PLAYER_SHIP_SPEED :: 1.5;
PLAYER_SHIP_ROTATION_SPEED :: .2;
PLAYER_SHIP_VELOCITY : Vector2 = .{ 0, -1 }; // Test vector

// Input stuff
DIRECTION_KEYBOARD_STATE : [4]bool;
DIR_KEY :: enum u8 {
  UP :: 0;
  DOWN;
  LEFT;
  RIGHT;
};

modify_player_ship_velocity :: (velocity: *Vector2, buttons: *bool, ship_speed: *float) {

}

prepare_player_ship :: (player_ship: *Vector2, center_x: float, center_y: float) {
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

render_player_ship :: (renderer: *SDL_Renderer, player_ship: *Vector2) {
  SDL_RenderDrawLine(renderer, cast(s32) player_ship[0].x, cast(s32) player_ship[0].y, cast(s32) player_ship[1].x, cast(s32) player_ship[1].y);
  SDL_RenderDrawLine(renderer, cast(s32) player_ship[1].x, cast(s32) player_ship[1].y, cast(s32) player_ship[2].x, cast(s32) player_ship[2].y);
  SDL_RenderDrawLine(renderer, cast(s32) player_ship[2].x, cast(s32) player_ship[2].y, cast(s32) player_ship[3].x, cast(s32) player_ship[3].y);
  SDL_RenderDrawLine(renderer, cast(s32) player_ship[3].x, cast(s32) player_ship[3].y, cast(s32) player_ship[4].x, cast(s32) player_ship[4].y);
}

move_player_ship :: (player_ship: *Vector2, velocity: Vector2, speed: float) {
  player_ship[0].x += velocity.x * speed;
  player_ship[0].y += velocity.y * speed;

  player_ship[1].x += velocity.x * speed;
  player_ship[1].y += velocity.y * speed;

  player_ship[2].x += velocity.x * speed;
  player_ship[2].y += velocity.y * speed;

  player_ship[3].x += velocity.x * speed;
  player_ship[3].y += velocity.y * speed;

  player_ship[4].x += velocity.x * speed;
  player_ship[4].y += velocity.y * speed;
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

  PLAYER_SHIP: [5] Vector2; // Awesome!
  PLAYER_SHIP_CENTER = .{ cast(float) WINDOW_WIDTH / 2, cast(float) WINDOW_HEIGHT / 2 };
  player_ship_speed := 1.5;

  print("Player ship: %\n", PLAYER_SHIP);
  prepare_player_ship(PLAYER_SHIP.data, cast(float) WINDOW_WIDTH / 2, cast(float) WINDOW_HEIGHT / 2);
  print("Player ship: %\n", PLAYER_SHIP);

  frame_start_time : u32;
  frame_end_time : u32;
  frame_duration : float = 0.0;

  exit := false;
  while !exit {
    // Frame counters
    frame_start_time = SDL_GetTicks();

    // Set some stuff
    // @TODO: This is stupid, but it's just a test
    DIRECTION_KEYBOARD_STATE[DIR_KEY.UP] = false;
    DIRECTION_KEYBOARD_STATE[DIR_KEY.DOWN] = false;
    DIRECTION_KEYBOARD_STATE[DIR_KEY.LEFT] = false;
    DIRECTION_KEYBOARD_STATE[DIR_KEY.RIGHT] = false;

    event : SDL_Event;
    while SDL_PollEvent(*event) {
      if event.type == {
        case SDL_QUIT;
          exit = true;
        case SDL_KEYUP;
          if event.key.keysym.sym == SDLK_ESCAPE exit = true;
        case SDL_KEYDOWN;
          if event.key.keysym.sym == SDLK_UP DIRECTION_KEYBOARD_STATE[DIR_KEY.UP] = true;
          if event.key.keysym.sym == SDLK_DOWN DIRECTION_KEYBOARD_STATE[DIR_KEY.DOWN] = true;
          if event.key.keysym.sym == SDLK_LEFT DIRECTION_KEYBOARD_STATE[DIR_KEY.LEFT] = true;
          if event.key.keysym.sym == SDLK_RIGHT DIRECTION_KEYBOARD_STATE[DIR_KEY.RIGHT] = true;
      }
    }

    // Simulate game loop
    print("Frame duration: %\n", frame_duration);
    modify_player_ship_velocity(*PLAYER_SHIP_VELOCITY, DIRECTION_KEYBOARD_STATE.data, *player_ship_speed);
    move_player_ship(PLAYER_SHIP.data, PLAYER_SHIP_VELOCITY, player_ship_speed);

    // Clear the screen
    SDL_SetRenderDrawColor(renderer, 0x18, 0x18, 0x18, 0xFF);
    SDL_RenderClear(renderer);

    // Render stuff
    set_render_draw_color(renderer, PLAYER_SHIP_COLOR);
    // SDL_RenderDrawLines(renderer, PLAYER_SHIP.data, PLAYER_SHIP.count);
    render_player_ship(renderer, PLAYER_SHIP.data);

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
