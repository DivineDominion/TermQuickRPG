require "curses"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class Viewport
      include Observable
      VIEWPORT_DID_SCROLL = :viewport_did_scroll
      BORDER_WIDTH = 1
      BORDERS_WIDTH = 2 * BORDER_WIDTH

      attr_reader :x, :y, :width, :height
      attr_accessor :keep_centered
      attr_reader :scroll_x, :scroll_y
      attr_reader :window

      def initialize(**attrs)
        attrs = {
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          borders_inclusive: false,
          keep_centered: false
        }.merge(attrs)

        @keep_centered = attrs[:keep_centered]

        border_delta = attrs[:borders_inclusive] ? BORDERS_WIDTH : 0
        @width, @height = attrs[:width] - border_delta, attrs[:height] - border_delta
        @x, @y = attrs[:x], attrs[:y]

        @scroll_x, @scroll_y = 0, 0

        if @keep_centered
          recenter_position(Screen.width, Screen.height)
        end

        @window = replace_window
      end

      def recenter_position(screen_width, screen_height)
        @x = @keep_centered ? (Screen.width - @width) / 2 : @x
        @y = @keep_centered ? (Screen.height - @height) / 2 : @y
      end

      def max_x
        x + width + BORDERS_WIDTH
      end

      def max_y
        y + height + BORDERS_WIDTH
      end

      def replace_window
        unless @window.nil?
          @window.erase
          @window.close
        end
        @window = Curses::Window.new(@height + BORDERS_WIDTH, @width + BORDERS_WIDTH, @y, @x)
      end

      def display
        return if Curses.closed?

        @window.clear
        @window.draw_box(:double)

        yield @scroll_x, @scroll_y, @width, @height

        @window.refresh
      end

      def player_did_move(player, x, y)
        if x < @scroll_x
          @scroll_x -= 1
          notify_listeners(VIEWPORT_DID_SCROLL)
        elsif y < @scroll_y
          @scroll_y -= 1
          notify_listeners(VIEWPORT_DID_SCROLL)
        elsif x >= @scroll_x + @width
          @scroll_x += 1
          notify_listeners(VIEWPORT_DID_SCROLL)
        elsif y >= @scroll_y + @height
          @scroll_y += 1
          notify_listeners(VIEWPORT_DID_SCROLL)
        end
      end

      def adjust_to_screen_size(width, height)
        move_to_fit_width(width)
        move_to_fit_height(height)
        recenter_position(width, height)
        replace_window
      end

      private

      def move_to_fit_width(width)
        while (width - max_x) < 0
          if @x > 0
            @x -= 1
          else
            @width -= 1
          end
        end
      end

      def move_to_fit_height(height)
        while (height - max_y) < 0
          if @y > 0
            @y -= 1
          else
            @height -= 1
          end
        end
      end
    end
  end
end
