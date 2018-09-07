require "curses"

module TermQuickRPG
  module UI
    module Color
      WHITE_BRIGHT = 255

      module Pair
        DEFAULT = 0 # B/W

        PLAYER = 100
        FLASH = 255
      end

      def self.setup
        # Reset colors
        Curses.use_default_colors

        # Highest B/W Contrast
        Curses.init_color(WHITE_BRIGHT, 1000, 1000, 1000)
        Curses.init_pair(Pair::FLASH, 254, 255)
        Curses.init_pair(Pair::PLAYER, Curses::COLOR_YELLOW, Curses::COLOR_BLACK)

        # Curses.init_pair(0, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
        Curses.stdscr.color_set(0)
      end
    end
  end
end
