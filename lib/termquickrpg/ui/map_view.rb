require "curses"
require "termquickrpg/ui/colors"

module TermQuickRPG
  module UI
    class MapView
      attr_reader :viewport
      attr_reader :map

      def initialize(map, viewport, screen)
        @viewport, @map = viewport, map
        map.add_listener(self)
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

      def draw(char, x, y, color = nil)
        color ||= UI::Color::Pair::DEFAULT
        canvas.setpos(y, x)
        canvas.attron(Curses::color_pair(color))
        canvas.addstr("#{char}")
        canvas.attroff(Curses::color_pair(color))
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

      def map_content_did_invalidate(map, flag_or_location)
        if (flag = flag_or_location) == true
          display
        elsif location = flag_or_location and is_in_viewport_bounds(flag_or_location)
          display
        end
      end

      def is_in_viewport_bounds(location)
        x, y = location
        mapx, mapy, width, height = viewport.map_bounds
        return (mapx <= x && x < mapx + width) \
            && (mapy <= y && y < mapy + height)
      end
    end
  end
end
