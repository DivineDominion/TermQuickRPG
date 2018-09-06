require "curses"

module Curses
  def self.screen_size_did_change(screen, width, height)
    Curses.resizeterm(height, width)

    # Clear artifacts of moved windows and labels
    Curses.clear
    Curses.refresh
  end

  class Window
    def height
      maxy
    end

    def width
      maxx
    end

    def size
      [width, height]
    end
  end
end
