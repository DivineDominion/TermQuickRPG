require "termquickrpg/ui/effects"

module TermQuickRPG
  module Script
    module EffectCommands
      def flash_screen(duration = 0.1)
        UI::Effects::flash_screen(duration)
        redraw_current_map
      end
    end
  end
end
