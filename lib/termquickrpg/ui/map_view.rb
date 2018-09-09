require "termquickrpg/ui/color"

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

      def close
        viewport.close
      end

      def render
        viewport.render do |start_x, start_y, width, height|
          @map.draw(viewport, start_x, start_y, width, height)
        end
      end

      # Event listener

      def viewport_size_did_change(viewport, width, height)
        render
      end

      def viewport_did_scroll(viewport)
        render
      end

      def map_content_did_invalidate(map, flag_or_location)
        if (flag = flag_or_location) == true
          render
        elsif location = flag_or_location and is_in_viewport_bounds(flag_or_location)
          render
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
