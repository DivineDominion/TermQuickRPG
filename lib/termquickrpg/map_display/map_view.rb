require "termquickrpg/ui/color"
require "termquickrpg/ui/view"

module TermQuickRPG
  module MapDisplay
    class MapView
      include UI::View

      attr_reader :viewport
      attr_reader :map

      def initialize(map, viewport)
        @viewport, @map = viewport, map
        map.add_listener(self)
        viewport.add_listener(self)
      end

      def window_did_close(window)
        viewport.close
      end

      def window_frame_did_change(window, origin, size)
        viewport.fill_window(window)
      end

      class OffsetDrawer
        attr_accessor :canvas, :offsets

        def initialize(canvas, offsets)
          @canvas, @offsets = canvas, offsets
        end

        def draw(char, x, y, color = nil)
          x_off, y_off = offsets
          x, y = x + x_off, y + y_off
          canvas.draw(char, x, y, color)
        end
      end

      def render(canvas: nil, **opts)
        raise unless canvas
        viewport.render do |start_x, start_y, width, height, x_off, y_off|
          drawer = OffsetDrawer.new(canvas, [x_off, y_off])
          @map.draw(drawer, start_x, start_y, width, height)
        end
      end

      # Event listener

      def viewport_did_scroll(viewport)
        needs_display!
      end

      def map_content_did_invalidate(map, flag_or_location)
        if (flag = flag_or_location) == true
          needs_display!
        elsif location = flag_or_location and is_in_viewport_bounds(flag_or_location)
          needs_display!
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
