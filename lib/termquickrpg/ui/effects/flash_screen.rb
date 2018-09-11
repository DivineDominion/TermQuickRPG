require "termquickrpg/control/window_registry"
require "termquickrpg/ui/color"

module TermQuickRPG
  module UI
    module Effects
      def self.flash_screen(duration)
        effect = Control::WindowRegistry.create_full_screen_effect

        effect.render do |win|
          UI::Color::Pair::FLASH.style(win)
          win.touch
          win.refresh

          sleep(duration)
        end

        Curses.clear
        effect.close
        Curses.refresh
      end
    end
  end
end