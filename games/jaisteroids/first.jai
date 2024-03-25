#import "Basic";
#import "Compiler";

OUTPUT_EXECUTABLE_NAME := "jaisteroids";

#run {
  set_build_options_dc(.{do_output = false});

  args := get_build_options().compile_time_command_line;

  w := compiler_create_workspace("Target workspace");
  options := get_build_options(w);

  options.output_executable_name = OUTPUT_EXECUTABLE_NAME;

  set_build_options(options, w);

  compiler_begin_intercept(w);
  add_build_file("src/jaisteroids.jai", w);

  while true {
    message := compiler_wait_for_message();
    if message.kind == {
      case .ERROR;
        exit(1);
      case .COMPLETE;
        break;
    }
  }

  compiler_end_intercept(w);
}

