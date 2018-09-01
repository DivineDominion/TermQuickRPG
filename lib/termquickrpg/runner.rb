require "curses"
require "termquickrpg/ext/curses/curses-resize"

require "termquickrpg/util/run_loop"
require "termquickrpg/ui/screen"
require "termquickrpg/ui/dialogs"
require "termquickrpg/ui/map_view"
require "termquickrpg/ui/viewport"
require "termquickrpg/ui/default_keys"
require "termquickrpg/world/player"
require "termquickrpg/world/item"
require "termquickrpg/world/map"


class Hash
  # case matching
  def ===(element)
    self.has_key?(element)
  end
end

module TermQuickRPG
  TITLE = "TerminalQuickRPG by DivineDominion / 2018"

  class Runner
    include World
    include UI
    include Util

    def screen; Screen.main; end

    def run(map, player)
      bootstrap

      begin
        run_loop(map, player)
      rescue => ex
        raise ex
      ensure
        teardown
      end
    end

    private

    attr_reader :player, :map
    attr_reader :map_views

    def bootstrap
      Curses.init_screen
      Curses.start_color
      Curses.stdscr.keypad(true) # enable arrow keys
      Curses.cbreak # no line buffering / immediate key input
      Curses.ESCDELAY = 0
      Curses.curs_set(0) # Invisible cursor
      Curses.noecho # Do not print keyboard input

      screen.add_listener(Curses)
    end

    def teardown
      Curses.close_screen
    end

    def run_loop(map, player)
      @map, @player = map, player
      @map_views ||= []

      viewport = Viewport.new(width: 30, height: 15, y: 2, borders_inclusive: true,
                              margin: {bottom: 2}, # bottom screen help lines
                              centered: [:horizontal])
      viewport.scroll_to_visible(player.x, player.y)
      player.add_listener(viewport) # scroll on move
      @map_views << MapView.new(map, viewport, screen)

      # Demo dual views
      viewport2 = Viewport.new(width: 8, height: 5, x: 100, borders_inclusive: true,
                              centered: [:vertical])
      viewport2.scroll_to_visible(player.x, player.y)
      player.add_listener(viewport2)
      @map_views << MapView.new(map, viewport2, screen)

      Curses.refresh

      @keep_running = true
      while @keep_running
        RunLoop.main.run do
          draw
          handle_input(player)
        end
      end
    end

    def draw
      draw_help
      display_map_views
    end

    def draw_help
      # Curses.setpos(0, 0)
#       Curses.addstr(  "player: #{player.x}, #{player.y}")
#       Curses.addstr("\nviewport: #{viewport.x}, #{viewport.y}; #{viewport.width}x#{viewport.height}; scroll: #{viewport.scroll_x}, #{viewport.scroll_y}")
#       Curses.addstr("\nc #{Curses.cols}x#{Curses.lines}; scr #{screen.width}x#{screen.height} : #{viewport.max_x},#{viewport.max_y} = #{screen.width-viewport.max_x}x#{screen.height-viewport.max_y}")

      Curses.setpos(Curses.lines - 2, (Curses.cols - TITLE.length) / 2)
      Curses.addstr(TITLE)

      help = "W,A,S,D to move  [Q]uit [I]nventory"
      Curses.setpos(Curses.lines - 1, (Curses.cols - help.length) / 2)
      Curses.addstr(help)
    end

    def display_map_views
      @map_views.each do |map_view|
        map_view.display
      end
    end

    def handle_input(player)
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
        handle_move_player(player, direction)

      when ACTION_KEYS
        action = ACTION_KEYS[input]

        UI::show_message("Cannot interact with anything here.")
        UI::cleanup_after_dialog

      else
        unless input.nil?
          # show_message("got #{input} / #{input.ord}")
        end
      end
    end

    def handle_move_player(player, direction)
      old_x, old_y = player.x, player.y

      if obj = player.would_collide_with_entities(map.entities, direction)
        player.move(direction)
        display_map_views # display new player position immediately

        choice = UI::show_options("Found #{obj.name}!", { pick: "Pick up", cancel: "Leave" }, :single)

        if choice == :pick
          map.entities.delete(obj)
          player.take(obj)
        end

        UI::cleanup_after_dialog
      elsif player.would_fit_into_map(map, direction)
        player.move(direction)
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
  end # Runner
end
