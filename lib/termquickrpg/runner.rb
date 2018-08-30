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
    attr_reader :screen

    include World
    include UI
    include Util

    def run
      bootstrap

      begin
        run_loop
      rescue => ex
        raise ex
      ensure
        teardown
      end
    end

    private

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

    def screen
      Screen.main
    end

    def teardown
      Curses.close_screen
    end

    def load_map
      # Map contents
      player = Player.new(5,5)

      entities = "The Adventure Begins ... Now".split("").map.with_index { |c, i| Item.new(2 + i, 2, c, c) }
      entities.delete_if { |e| e.name == " " }
      entities << Item.new(8, 6, "♥", "Heart")
      entities << Item.new(4, 4, "¶", "Mace")
      entities << player

      map = Map.new(34, 30, entities)

      [map, player]
    end

    def run_loop
      map, player = load_map

      viewport = Viewport.new(centered: [:horizontal, :vertical], width: 30, height: 15, borders_inclusive: true)
      player.add_listener(viewport) # scroll on move

      map_view = MapView.new(map, viewport)
      screen.add_listener(map_view) # forward screen resizing

      Curses.refresh

      quit = false
      while !quit
        RunLoop.main.run do
          Curses.setpos(0, 0)
          Curses.addstr(  "player: #{player.x}, #{player.y}")
          Curses.addstr("\nviewport: #{viewport.x}, #{viewport.y}; #{viewport.width}x#{viewport.height}; scroll: #{viewport.scroll_x}, #{viewport.scroll_y}")
          Curses.addstr("\nc #{Curses.cols}x#{Curses.lines}; scr #{screen.width}x#{screen.height} : #{viewport.max_x},#{viewport.max_y} = #{screen.width-viewport.max_x}x#{screen.height-viewport.max_y}")

          Curses.setpos(Curses.lines - 1, (Curses.cols - TITLE.length) / 2)
          Curses.addstr(TITLE)

          map_view.display

          input = Curses.get_char

          case input
          when "q", "Q", "\e", Curses::Key::EXIT, Curses::Key::CANCEL, Curses::Key::BREAK
            quit = true # faster during dev
            # case show_options("Quit?", { yes: "Yes", cancel: "No" }, :double)
            # when :yes then quit = true
            # else redraw_window.call
            # end

          when DIRECTION_KEYS
            direction = DIRECTION_KEYS[input]
            old_x, old_y = player.x, player.y

            if obj = player.would_collide_with_entities(map.entities, direction)
              player.move(direction)
              map_view.display # display new player position immediately

              choice = UI::show_options("Found #{obj.name}!", { pick: "Pick up", cancel: "Leave" }, :single)

              if choice == :pick
                map.entities.delete(obj)
              end

              UI::cleanup_after_dialog
            elsif player.would_fit_into_map(map, direction)
              player.move(direction)
            end

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
      end
    end
  end
end
