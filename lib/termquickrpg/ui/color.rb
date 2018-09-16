require "curses"

module TermQuickRPG
  module UI
    class Color
      attr_reader :index, :fg, :bg

      def initialize(index, fg, bg)
        raise "Cannot override system default color pair 0" if index == 0
        @index, @fg, @bg = index, fg, bg
      end

      def register
        Curses.init_pair(index, fg, bg)
      end

      def color_pair
        Curses.color_pair(index)
      end

      def set(canvas)
        if block_given?
          set(canvas)
          yield
          unset(canvas)
        else
          canvas.attron(color_pair)
        end
      end

      def unset(canvas)
        canvas.attroff(color_pair)
      end

      def style(window)
        window.bkgd(color_pair)
        window.color_set(color_pair)
      end

      def self.setup
        # Reset colors
        Curses.use_default_colors

        # Highest B/W Contrast
        Curses.init_color(WHITE_BRIGHT, 1000, 1000, 1000)

        Pair.constants
          .map { |name| Pair.const_get(name) }
          .each { |c| c.register }
      end

      WHITE_BRIGHT = 255

      module Pair
        DEFAULT = Color.new(1, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
        BATTLE_UI = Color.new(50, Curses::COLOR_WHITE, Curses::COLOR_RED)
        PLAYER = Color.new(100, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)
        FLASH = Color.new(255, WHITE_BRIGHT, WHITE_BRIGHT)
      end
    end
  end
end
