require "curses"
require "termquickrpg/ui/color"

module Curses
  class Window
    def draw(char, x, y, color = nil)
      color ||= TermQuickRPG::UI::Color::Pair::DEFAULT
      setpos(y, x)
      color.set(self) do
        addstr("#{char}")
      end
    end
  end
end
