require "curses"

module TermQuickRPG
  module UI
    module Colors
      WHITE_BRIGHT = 255
      PAIR_FLASH = 255

      def self.setup
        # Reset colors
        Curses.use_default_colors

        # Highest B/W Contrast
        Curses.init_color(WHITE_BRIGHT, 1000, 1000, 1000)
        Curses.init_pair(PAIR_FLASH, 254, 255)

        Curses.init_pair(0, Curses::COLOR_WHITE, Curses::COLOR_BLACK)
        Curses.stdscr.color_set(0)
      end
    end
  end
end
