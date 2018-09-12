require "curses"
require "termquickrpg/control/game_runner"
require "termquickrpg/control/map_stack"
require "termquickrpg/control/window_registry"
require "termquickrpg/ui/screen"
require "termquickrpg/ui/color"
require "termquickrpg/script/context"

module TermQuickRPG
  class Bootstrap
    attr_reader :launch, :game_dir

    def initialize(**opts)
      @launch = opts[:launch] or raise "Missing :launch parameter"
      @game_dir = opts[:game_dir] or raise "Missing :game_dir parameter"
    end

    def game_runner
      @game_runner ||= Control::GameRunner.instance
    end

    def run
      bootstrap_ui
      bootstrap_game
      game_loop
    rescue => ex
      raise ex
    ensure
      teardown
    end

    def bootstrap_ui
      Curses.init_screen
      Curses.start_color
      Curses.stdscr.keypad(true) # enable arrow keys
      Curses.cbreak # no line buffering / immediate key input
      Curses.ESCDELAY = 0
      Curses.curs_set(0) # Invisible cursor
      Curses.noecho # Do not print keyboard input

      UI::Color.setup

      UI::Screen.main.add_listener(Curses)

      Control::WindowRegistry.create_help_line_window
    end

    def bootstrap_game
      Script::Context.main.game_dir = game_dir

      # Listen to map changes before launch to forward script events
      Control::MapStack.instance.add_listener(game_runner)
      Script::Context.main.run(&launch)
    end

    def game_loop
      game_runner.game_loop
    end

    def teardown
      Curses.use_default_colors # Reset to system defaults
      Curses.close_screen
    end
  end
end
