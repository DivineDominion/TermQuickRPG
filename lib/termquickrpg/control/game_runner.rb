require "curses"
require "termquickrpg/ext/curses/curses-resize"

require "termquickrpg/ui/help_line_window"
require "termquickrpg/control/run_loop"
require "termquickrpg/ui/screen"
require "termquickrpg/ui/dialogs"
require "termquickrpg/ui/map_view"
require "termquickrpg/ui/viewport"
require "termquickrpg/control/default_keys"
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
  module Control
    class GameRunner
      attr_reader :player, :map

      def map_views
        @map_views ||= []
      end

      def help_line_window
        @help_line_window ||= UI::HelpLineWindow.new
      end

      def map_stack_did_change(map_stack)
        close_map(@map)

        if map = map_stack.front
          @map = map
          @player ||= Control::Player.instance
          @player.switch_control(map.player_character)
          show_map(map)
        else
          @map = nil
          @player = nil
        end
      end

      def show_map(map)
        viewport = UI::Viewport.new(width: 30, height: 15, y: 2, borders_inclusive: true,
                                    margin: {bottom: 2}, # bottom screen help lines
                                    centered: [:horizontal])
        viewport.scroll_to_visible(map.player_character)
        viewport.track_movement(map.player_character)
        map_views << UI::MapView.new(map, viewport, UI::Screen.main)

        # # Demo dual views
        # viewport2 = UI::Viewport.new(width: 8, height: 5, x: 100, borders_inclusive: true,
        #                             centered: [:vertical])
        # viewport2.scroll_to_visible(map.player_character)
        # viewport2.track_movement(map.player_character)
        # map_views << UI::MapView.new(map, viewport2, UI::Screen.main)

        Curses.refresh
      end

      def close_map(map)
        map_views.each_with_index do |map_view, index|
          if map_view.map == map
            map_view.close
            map_views.delete_at(index)
          end
        end
        Curses.refresh
      end

      def game_loop
        @keep_running = true
        while @keep_running
          Control::RunLoop.main.run do
            draw
            handle_input
            GC.start # Clean up weak references of observers
          end
        end
      end

      def draw
        draw_help
        display_map_views
      end

      def draw_help
        help_line_window.draw
        # Curses.setpos(0, 0)
        # Curses.addstr(  "player: #{@player.x}, #{@player.y}")

  #       Curses.addstr("\nviewport: #{viewport.x}, #{viewport.y}; #{viewport.width}x#{viewport.height}; scroll: #{viewport.scroll_x}, #{viewport.scroll_y}")
  #       Curses.addstr("\nc #{Curses.cols}x#{Curses.lines}; scr #{screen.width}x#{screen.height} : #{viewport.max_x},#{viewport.max_y} = #{screen.width-viewport.max_x}x#{screen.height-viewport.max_y}")
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

        when Control::DIRECTION_KEYS
          direction = Control::DIRECTION_KEYS[input]
          player.move(map, direction)

        when Control::ACTION_KEYS
          action = Control::ACTION_KEYS[input]
          handle_use_object(player)

        else
          unless input.nil?
            # show_message("got #{input} / #{input.ord}")
          end
        end
      end

      def handle_use_object(player)
        player.interact(map)
      end

      def show_inventory(player)
        if item = player.item_from_inventory
          if effect = item.apply(player)
            UI::show_message(effect)
          end
        end
      end
    end
  end
end
