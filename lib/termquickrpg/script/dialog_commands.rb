require "termquickrpg/ui/view_components"

module TermQuickRPG
  module Script
    module DialogCommands
      def msg(*lines)
        UI::show_message(*lines)
      ensure
        Control::WindowRegistry.instance.render_window_stack
      end

      def dialogue(who, *lines)
        UI::show_dialogue(who, *lines)
      ensure
        Control::WindowRegistry.instance.render_window_stack
      end

      def request_use_item(message, &block)
        if item = Control::Player.instance.item_from_inventory(message)
          Control::WindowRegistry.instance.render_window_stack
          yield item
          return true
        else
          return false
        end
      end
    end
  end
end
