require "curses"

module TermQuickRPG
  module UI
    class MapView
      attr_reader :viewport
      attr_reader :map

      def initialize(map, viewport)
        @viewport, @map = viewport, map
        viewport.add_listener(self)
      end

      def window
        @viewport.window
      end

      def display
        viewport.display do |start_x, start_y, width, height|
          @map.draw(self, start_x, start_y, width, height)
        end
      end

      def draw(char, map_x, map_y)
        x, y = [map_x + 1, map_y + 1] # window border
        old_y, old_x = [window.cury, window.curx]
        window.setpos(y, x)
        window.addstr("#{char}")
        window.setpos(old_y, old_x)
      end

      def undraw(map_x, map_y)
        draw(" ", map_x, map_y)
      end

      # Event listener
      def screen_size_did_change(screen, width, height)
        viewport.adjust_to_screen_size(width, height)
        display
      end

      def viewport_did_scroll(viewport)
        display
      end
    end
  end
end
