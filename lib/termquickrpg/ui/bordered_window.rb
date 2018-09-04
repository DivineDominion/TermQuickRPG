require "curses"
require "termquickrpg/ext/curses/curses-resize"

module TermQuickRPG
  module UI
    class BorderedWindow
      BORDER_WIDTH = 1
      BORDERS_WIDTH = 2 * BORDER_WIDTH

      attr_reader :x, :y, :width, :height
      attr_reader :original_x, :original_y, :original_width, :original_height
      attr_accessor :centered
      attr_accessor :margin_bottom
      attr_reader :frame, :content

      def initialize(**attrs)
        attrs = {
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          centered: false,
          margin: {}
        }.merge(attrs)

        @centered = [*attrs[:centered]]
        @margin_bottom = attrs[:margin][:bottom] || 0

        @width, @height = attrs[:width], attrs[:height]
        @x, @y = attrs[:x], attrs[:y]

        # Cache original positions for restoring later
        @original_width, @original_height = @width, @height
        @original_x, @original_y = @x, @y

        recenter_position(Screen.width, Screen.height)

        @frame, @content = replace_window
      end

      def content_size
        @content.size
      end

      def recenter_position(screen_width, screen_height)
        @x = @centered.include?(:horizontal) ? (Screen.width - @width) / 2   : @x
        @y = @centered.include?(:vertical)   ? (Screen.height - @height) / 2 : @y
      end

      def close
        unless @frame.nil?
          @frame.erase
          @frame.close
        end
      end

      def replace_window
        close
        @frame = Curses::Window.new(@height, @width, @y, @x)
        @content = @frame.subwin(@height - 2 * BORDER_WIDTH, @width - 2 * BORDER_WIDTH,
                                 @y + BORDER_WIDTH, @x + BORDER_WIDTH)
        [@frame, @content]
      end

      def draw
        return if Curses.closed?

        @frame.clear
        @frame.touch # Touch before refreshing subwindows
        @frame.draw_box(:double)

        yield

        @frame.refresh
      end

      def adjust_to_screen_size(width, height)
        # grow back when enlarging
        restore_original_dimension

        # fit to screen
        frame_to_fit_width(width)
        frame_to_fit_height(height)

        recenter_position(width, height)

        @frame.move(@y, @x)
        @frame.resize(@height, @width)
        @content.resize(@height - 2 * BORDER_WIDTH, @width - 2 * BORDER_WIDTH)
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