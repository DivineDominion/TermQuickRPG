require "curses"
require_relative "observable.rb"

module TermQuickRPG
  class Viewport
    include Observable
    VIEWPORT_DID_SCROLL = :viewport_did_scroll
    BORDERS_WIDTH = 2

    attr_reader :x, :y, :width, :height
    attr_reader :scroll_x, :scroll_y
    attr_reader :window

    def initialize(x, y, width, height)
      @x, @y, @width, @height = x, y, width, height
      @scroll_x, @scroll_y = 0, 0
      @window = create_window
    end

    def max_x
      x + width + 2 * border_width
    end

    def max_y
      y + height + 2 * border_width
    end

    def border_width
      1
    end

    def adjust_to_screen_size(width, height)
      did_change = false

      diff_x = width - max_x
      if diff_x < 0
        while diff_x < 0
          if @x > 0
            @x -= 1
          else
            @width -= 1
          end
          diff_x += 1
        end
        did_change = true
      end

      diff_y = height - max_y
      if diff_y < 0
        while diff_y < 0
          if @y > 0
            @y -= 1
          else
            @height -= 1
          end
          diff_y += 1
        end
        did_change = true
      end

      if did_change
        create_window
      end
    end

    def create_window
      unless @window.nil?
        @window.erase
        @window.close
      end
      @window = Curses::Window.new(@height + 2 * border_width, @width + 2 * border_width, @y, @x)
    end

    def display
      @window.clear
      @window.box(?|, ?-)

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
  end
end
