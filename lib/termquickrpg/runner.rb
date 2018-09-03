require "curses"
require "termquickrpg/ext/curses/curses-resize"

require "termquickrpg/control/run_loop"
require "termquickrpg/ui/screen"
require "termquickrpg/ui/dialogs"
require "termquickrpg/ui/map_view"
require "termquickrpg/ui/viewport"
require "termquickrpg/ui/default_keys"
require "termquickrpg/control/player"
require "termquickrpg/control/map_stack"
require "termquickrpg/script/context"

class Hash
  # case matching
  def ===(element)
    self.has_key?(element)
  end
end

module TermQuickRPG
  TITLE = "TerminalQuickRPG by DivineDominion / 2018"

  class Runner
    include UI

    attr_reader :player, :map

    def initialize(**opts)
      opts = {
        launch: -> { raise "Missing :launch parameter in Runner" }
      }.merge(opts)
      Script::Context.main.game_dir = opts[:game_dir]
      Control::MapStack.instance.add_listener(self) # Listen before launch
      Script::Context.main.run(&opts[:launch])
    end

    def map_views
      @map_views ||= []
    end

    def map_stack_did_change(map_stack)
      close_map(@map)

      if map = map_stack.front
        @map = map
        @player ||= Control::Player.new
        @player.switch_control(map.player_character)
        show_map(map)
      else
        @map = nil
        @player = nil
      end
    end

    def screen; Screen.main; end

    def run
      bootstrap_ui
      run_loop
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

      screen.add_listener(Curses)
    end

    def close_map(map)
      map_views.each_with_index do |map_view, index|
        if map_view.map == map
          map_view.close
          map_view.map.player_character.remove_listener(map_view.viewport)
          map_views.delete_at(index)
        end
      end
      Curses.refresh
    end

    def show_map(map)
      viewport = Viewport.new(width: 30, height: 15, y: 2, borders_inclusive: true,
                              margin: {bottom: 2}, # bottom screen help lines
                              centered: [:horizontal])
      viewport.scroll_to_visible(map.player_character)
      viewport.track_movement(map.player_character)
      map_views << MapView.new(map, viewport, screen)

      # # Demo dual views
      viewport2 = Viewport.new(width: 8, height: 5, x: 100, borders_inclusive: true,
                              centered: [:vertical])
      viewport2.scroll_to_visible(map.player_character)
      viewport2.track_movement(map.player_character)
      map_views << MapView.new(map, viewport2, screen)

      Curses.refresh
    end

    def teardown
      Curses.close_screen
    end

    def run_loop
      @keep_running = true
      while @keep_running
        Control::RunLoop.main.run do
          draw
          handle_input
        end
      end
    end

    def draw
      draw_help
      display_map_views
    end

    def draw_help
      # Curses.setpos(0, 0)
      # Curses.addstr(  "player: #{@player.x}, #{@player.y}")

#       Curses.addstr("\nviewport: #{viewport.x}, #{viewport.y}; #{viewport.width}x#{viewport.height}; scroll: #{viewport.scroll_x}, #{viewport.scroll_y}")
#       Curses.addstr("\nc #{Curses.cols}x#{Curses.lines}; scr #{screen.width}x#{screen.height} : #{viewport.max_x},#{viewport.max_y} = #{screen.width-viewport.max_x}x#{screen.height-viewport.max_y}")

      Curses.setpos(Curses.lines - 2, (Curses.cols - TITLE.length) / 2)
      Curses.addstr(TITLE)

      help = "W,A,S,D to move  [I]nventory Us[e] [Q]uit "
      Curses.setpos(Curses.lines - 1, (Curses.cols - help.length) / 2)
      Curses.addstr(help)
    end

    def display_map_views
      @map_views.each do |map_view|
        map_view.display
      end
    end

    def handle_input
      input = Curses.get_char

      case input
      when "q", "Q", "\e", Curses::Key::EXIT, Curses::Key::CANCEL, Curses::Key::BREAK
        @keep_running = false # faster during dev
        # case show_options("Quit?", { yes: "Yes", cancel: "No" }, :double)
        # when :yes then @keep_running = false
        # else redraw_window.call
        # end

      when "I", "i"
        show_inventory(player)

      when DIRECTION_KEYS
        direction = DIRECTION_KEYS[input]
        player.move(map, direction)

      when ACTION_KEYS
        action = ACTION_KEYS[input]
        handle_use_object(player)

      else
        unless input.nil?
          # show_message("got #{input} / #{input.ord}")
        end
      end
    end

    def handle_use_object(player)
      if obj = player.usable_entity(map)
        choice = UI::show_options("Found #{obj.name}!", { pick: "Pick up", cancel: "Leave" }, :single)

        if choice == :pick
          map.entities.delete(obj)
          player.take(obj)
        end

        UI::cleanup_after_dialog
      else
        UI::show_message("Cannot interact with anything here.")
        UI::cleanup_after_dialog
      end
    end

    def show_inventory(player)
      if player.inventory.empty?
        UI::show_message("Inventory is empty.")
      else
        items = player.inventory.map { |item| "#{item.char}   #{item.name}" }
        choice = UI::show_options("Inventory", ["Cancel", *items], :single)

        if choice > 0
          item_index = choice - 1 # "Cancel" offset
          item = player.inventory.delete_at(item_index)
          effect = item.apply(player)
          if effect
            UI::show_message(effect)
          end
        end
      end

      UI::cleanup_after_dialog
    end
  end
end
