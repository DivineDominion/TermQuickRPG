require "termquickrpg/control/default_keys"

module TermQuickRPG
  module Control
    class UserInput
      def process(player, map)
        input = Curses.get_char

        case input
        when Control::CANCEL_KEYS # Any cancel variant will quit
          if UI::show_options("Quit?", { quit: "Yes", cancel: "No" }, :double) == :quit
            Control::GameRunner.instance.quit!
          end

        when "r"
          Control::WindowRegistry.instance.refresh_window_stack
        when "R"
          Control::WindowRegistry.instance.render_window_stack
        when "t"
          `say "#{Control::WindowRegistry.instance.windows.count} wins"`

        when "I", "i"
          show_inventory(player)

        when Control::DIRECTION_KEYS
          direction = Control::DIRECTION_KEYS[input]
          player.move(map, direction)

        when Control::ACTION_KEYS
          if Control::ACTION_KEYS[input] == :use
            handle_use_object(player, map)
          end

        else
          unless input.nil?
            # show_message("got #{input} / #{input.ord}")
          end
        end
      end

      def handle_use_object(player, map)
        player.interact(map)
      end

      def show_inventory(player)
        return unless item = player.item_from_inventory
        return unless effect = item.apply(player)
        UI::show_message(effect)
      end
    end
  end
end