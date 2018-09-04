require "termquickrpg/ui/colors"

module TermQuickRPG
  module UI
    module Effects
      class << self
        def flash_screen(duration)
          Curses.refresh
          win = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
          win.bkgd(Curses::color_pair(UI::Colors::PAIR_FLASH))
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
end