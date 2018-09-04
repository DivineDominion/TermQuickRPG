require "curses"

module TermQuickRPG
  module UI
    class MapView
      attr_reader :viewport
      attr_reader :map

      def initialize(map, viewport, screen)
        @viewport, @map = viewport, map
        viewport.add_listener(self)
      end

      def canvas
        @viewport.canvas
      end

      def close
        viewport.close
      end

      def display
        viewport.draw do |start_x, start_y, width, height|
          @map.draw(self, start_x, start_y, width, height)
        end
      end

      def draw(char, x, y)
        canvas.setpos(y, x)
        canvas.addstr("#{char}")
      end

      def undraw(map_x, map_y)
        draw(" ", map_x, map_y)
      end

      # Event listener

      def viewport_size_did_change(viewport, width, height)
        display
      end

      def viewport_did_scroll(viewport)
        display
      end
    end
  end
end
