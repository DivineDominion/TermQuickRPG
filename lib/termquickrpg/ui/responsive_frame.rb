require "termquickrpg/ui/screen"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class ResponsiveFrame
      include Observable

      attr_reader :x, :y, :width, :height
      attr_reader :original_x, :original_y, :original_width, :original_height
      attr_reader :centered

      attr_accessor :padding
      attr_accessor :margin_bottom

      def initialize(**attrs)
        attrs = {
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          centered: false,
          margin: {},
          padding: {horizontal: 0, vertical: 0},
          screen: Screen.main
        }.merge(attrs)

        @x, @y = attrs[:x], attrs[:y]
        @centered = [*attrs[:centered]]
        @margin_bottom = attrs[:margin][:bottom] || 0

        @padding = attrs[:padding].is_a?(Array) \
          ? [:horizontal, :vertical].zip(attrs[:padding]) \
          : attrs[:padding]
        @width = attrs[:width] + 2 * @padding[:horizontal]
        @height = attrs[:height] + 2 * @padding[:vertical]

        # Cache original positions for restoring later
        @original_width, @original_height = @width, @height
        @original_x, @original_y = @x, @y

        # forward screen resizing
        if screen = attrs[:screen]
          screen.add_listener(self)
        end
      end

      def size
        [width, height]
      end

      def origin
        [x, y]
      end

      def screen_size_did_change(screen, screen_width, screen_height)
        adjust_to_screen_size(screen_width, screen_height)
      end

      def adjust_to_screen_size(screen_width, screen_height)
        # grow back when enlarging
        restore_original_dimension

        frame_to_fit_width(screen_width)
        frame_to_fit_height(screen_height)

        recenter_position(screen_width, screen_height)

        notify_listeners(:frame_did_change, @x, @y, @width, @height)
      end

      def recenter_position(screen_width, screen_height)
        @x = @centered.include?(:horizontal) ? (screen_width - @width) / 2   : @x
        @y = @centered.include?(:vertical)   ? (screen_height - @height) / 2 : @y
      end

      private

      def restore_original_dimension
        @width, @height = @original_width, @original_height
        @x, @y = @original_x, @original_y
      end

      def frame_to_fit_width(width)
        while (width - max_x) < 0
          if @x > 0
            @x -= 1
          else
            @width -= 1
          end
        end
      end

      def max_x
        x + width
      end

      def frame_to_fit_height(height)
        while (height - max_y) < 0
          if @y > 0
            @y -= 1
          else
            @height -= 1
          end
        end
      end

      def max_y
        y + height + margin_bottom
      end
    end
  end
end