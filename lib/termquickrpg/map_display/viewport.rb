require "forwardable"
require "termquickrpg/control/window_registry"
require "termquickrpg/observable"
require "termquickrpg/ext/curses/window-canvas"

module TermQuickRPG
  module MapDisplay
    class Viewport
      include Observable

      attr_reader :scroll_x, :scroll_y
      # -1: keep camera centered
      #  0: scroll when touching the frame
      attr_writer :original_scroll_padding
      attr_reader :scroll_padding
      attr_reader :overscroll

      attr_reader :frame_origin
      attr_reader :canvas_size

      def initialize(**attrs)
        @scroll_x, @scroll_y = 0, 0
        @original_scroll_padding = attrs[:scroll_padding] || [0, 0]
      end

      def close
        notify_listeners(:viewport_did_close)
      end

      def fill_window(window)
        @frame_origin = window.origin
        @canvas_size = window.content_size
        adjust_scroll_padding
      end

      def translate_map_to_screen(location)
        x, y = location
        scroll_x, scroll_y = map_bounds
        x_off, y_off = overscroll
        x_frame, y_frame = frame_origin
        return [x - scroll_x + x_off + x_frame,
                y - scroll_y + y_off + y_frame]
      end

      def render
        yield *map_bounds, *overscroll
      end

      # Scrolling & resizing

      def map_bounds
        width, height = canvas_size.zip(overscroll).map { |arr| arr.reduce(&:-)}
        x, y = [scroll_x, 0].max, [scroll_y, 0].max # start location is never negative
        [x, y, width, height]
      end

      def track_movement(character)
        character.add_listener(self) # :character_did_move
      end

      def center_on(obj)
        x, y = obj.respond_to?(:location) ? obj.location : obj
        canvas_width, canvas_height = canvas_size
        @scroll_x, @scroll_y = x - (canvas_width / 2), y - (canvas_height / 2)
        adjust_overscroll
      end

      def character_did_move(character, from, to)
        scroll_to_visible(to)
      end

      private

      def scroll_to_visible(obj)
        x, y = obj.respond_to?(:location) ? obj.location : obj
        canvas_width, canvas_height = canvas_size
        x_pad, y_pad = scroll_padding

        x_min = scroll_x + x_pad
        x_max = scroll_x + canvas_width - 1 - x_pad
        x_diff = if x < x_min
                   x - x_min
                 elsif x > x_max
                   x - x_max
                 else
                   0
                 end

        y_min = scroll_y + y_pad
        y_max = scroll_y + canvas_height - 1 - y_pad
        y_diff = if y < y_min
                   y - y_min
                 elsif y > y_max
                   y - y_max
                 else
                   0
                 end

        @scroll_x = scroll_x + x_diff
        @scroll_y = scroll_y + y_diff
        adjust_overscroll
      ensure
        notify_listeners(:viewport_did_scroll) if (x_diff != 0 || y_diff != 0)
      end

      def adjust_overscroll
        @overscroll = [(@scroll_x...0).count, (@scroll_y...0).count]
      end

      # Prevent scroll_padding to overlap when canvas is too small.
      # Keep axis centered when set to -1.
      def adjust_scroll_padding
        width, height = canvas_size
        original_pad_x, original_pad_y = @original_scroll_padding
        pad_x = (original_pad_x == -1) ? width / 2  : [original_pad_x, width / 2].min
        pad_y = (original_pad_y == -1) ? height / 2 : [original_pad_y, height / 2].min
        @scroll_padding = [pad_x, pad_y]
      end
    end
  end
end
