require "termquickrpg/ui/effects"

module TermQuickRPG
  module Script
    module EffectCommands
      def flash_screen(duration = 0.1)
        UI::Effects::flash_screen(duration)
      ensure
        Control::WindowRegistry.instance.render_window_stack(force: true)
      end
    end
  end
end
