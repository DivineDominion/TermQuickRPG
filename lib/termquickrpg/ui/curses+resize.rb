require "curses"

module Curses
  def self.screen_size_did_change(screen, width, height)
    Curses.resizeterm(height, width)
  end
end
