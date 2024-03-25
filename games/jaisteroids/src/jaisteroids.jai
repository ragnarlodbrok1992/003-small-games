#import "Basic";
#import "Window_Creation";

Simp :: #import "Simp";
Input :: #import "Input";

GAME_WINDOW: Window_Type;
WINDOW_WIDTH  : s32 = 1920;
WINDOW_HEIGHT : s32 = 1080;

main :: () {
  // Welcome - goodbye messages
  print("Jaisteroids - alpha version.");
  defer print("Goodbye");

  #if OS == .WINDOWS {
    Windows :: #import "Windows";
    Windows.SetProcessDPIAware();
    Windows.timeBeginPeriod(1);
  }

  WANTED_MSAA :: 8;
  GAME_WINDOW = create_window(WINDOW_WIDTH, WINDOW_HEIGHT, "Jaisteroids", wanted_msaa = WANTED_MSAA);
  msaa := Simp.prepare_window(GAME_WINDOW, wanted_msaa = WANTED_MSAA);
  log("Wanted MSAA: %\nChosen MSAA: %", WANTED_MSAA, msaa);

  WINDOW_WIDTH, WINDOW_HEIGHT = Simp.get_render_dimensions(GAME_WINDOW);
  Simp.set_render_target(GAME_WINDOW, .LEFT_HANDED); // Idk if in 2D game it matters

  ENGINE_QUIT := false;

  while !ENGINE_QUIT {
    // Input handling
    Input.update_window_events();
    for Input.events_this_frame {
      if it.type == .QUIT then ENGINE_QUIT = true;

      if it.type == {
        case .KEYBOARD;
          if it.key_pressed && it.key_code == .ESCAPE {
            ENGINE_QUIT = true;
          }
      }
    }

    // Simulate stuff

    // Rest of the game loop
    sleep_milliseconds(10);
    reset_temporary_storage();
  }
}

#run {
  #if OS == .WINDOWS {
    WR :: #import "Windows_Resources";
    WR.disable_runtime_console();
  }
}
