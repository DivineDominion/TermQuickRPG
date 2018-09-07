require "termquickrpg/ui/color"

module TermQuickRPG
  module UI
    module Effects
      def self.flash_screen(duration)
        Curses.refresh
        win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
        UI::Color::Pair::FLASH.style(win)
        win.touch
        win.refresh

        sleep(duration)

        win.erase
        win.close

        Curses.clear
        Curses.refresh
      end
    end
  end
end