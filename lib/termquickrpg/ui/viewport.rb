require "curses"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class Viewport
      include Observable
      VIEWPORT_DID_SCROLL = :viewport_did_scroll
      BORDER_WIDTH = 1
      BORDERS_WIDTH = 2 * BORDER_WIDTH

      attr_reader :original_x, :original_y, :original_width, :original_height
      attr_reader :x, :y, :width, :height
      attr_accessor :centered
      attr_accessor :margin_bottom
      attr_reader :scroll_x, :scroll_y
      attr_reader :window

      def initialize(**attrs)
        attrs = {
          x: 0,
          y: 0,
          width: 10,
          height: 10,
          borders_inclusive: false,
          centered: false,
          margin: {}
        }.merge(attrs)

        @centered = [*attrs[:centered]]
        @margin_bottom = attrs[:margin][:bottom] || 0

        border_delta = attrs[:borders_inclusive] ? BORDERS_WIDTH : 0
        @width, @height = attrs[:width] - border_delta, attrs[:height] - border_delta
        @original_width, @original_height = @width, @height

        @x, @y = attrs[:x], attrs[:y]
        @original_x, @original_y = @x, @y
        recenter_position(Screen.width, Screen.height)

        @scroll_x, @scroll_y = 0, 0

        @window = replace_window
      end

      def recenter_position(screen_width, screen_height)
        @x = @centered.include?(:horizontal) ? (Screen.width - @width) / 2   : @x
        @y = @centered.include?(:vertical)   ? (Screen.height - @height) / 2 : @y
      end

      def close
        unless @window.nil?
          @window.erase
          @window.close
        end
      end

      def replace_window
        close
        @window = Curses::Window.new(@height + BORDERS_WIDTH, @width + BORDERS_WIDTH, @y, @x)
      end

      def display
        return if Curses.closed?

        @window.clear
        @window.draw_box(:double)

        yield @scroll_x, @scroll_y, @width, @height

        @window.refresh
      end

      def track_movement(character)
        character.add_listener(self) # :character_did_move
      end

      def character_did_move(character, x, y)
        scroll_to_visible([x, y])
      end

      def scroll_to_visible(obj)
        x, y = obj.respond_to?(:location) ? obj.location : obj

        did_scroll = false

        while x < @scroll_x
          @scroll_x -= 1
          did_scroll = true
        end

        while y < @scroll_y
          @scroll_y -= 1
          did_scroll = true
        end

        while x >= @scroll_x + @width
          @scroll_x += 1
          did_scroll = true
        end

        while y >= @scroll_y + @height
          @scroll_y += 1
          did_scroll = true
        end

        if did_scroll
          notify_listeners(VIEWPORT_DID_SCROLL)
        end
      end

      def adjust_to_screen_size(width, height)
        # grow back when enlarging
        restore_original_dimension

        # fit to screen
        frame_to_fit_width(width)
        frame_to_fit_height(height)

        recenter_position(width, height)
        replace_window
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
        x + width + BORDERS_WIDTH
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
        y + height + BORDERS_WIDTH + margin_bottom
      end
    end
  end
end
