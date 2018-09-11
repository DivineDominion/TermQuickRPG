require "termquickrpg/inventory/inventory_window"
require "termquickrpg/control/default_keys"

module TermQuickRPG
  module Inventory
    class InventoryController
      def show_picker(items, title = nil, window = InventoryWindow.new)
        window.items = items
        window.customize_title(title) # `nil` shows default

        selected_item = items.empty? ? nil : 0
        picked_item, did_cancel = nil, false
        while !(picked_item || did_cancel) do
          window.select_item(selected_item)
          window.render
          input = Curses.get_char

          case input
          when Control::ACTION_KEYS
            if Control::ACTION_KEYS[input] == :use
              if selected_item
                picked_item = items[selected_item]
              else
                did_cancel = true
              end
            else
              Audio::Sound::beep
            end

          when Control::CANCEL_KEYS # Cancel or quit will close
            did_cancel = true

          when Control::DIRECTION_KEYS
            if items.empty?
              Audio::Sound::beep
            else
              case Control::DIRECTION_KEYS[input]
              when :up
                if selected_item
                  selected_item -= 1
                else
                  selected_item = items.count - 1
                end
              when :down
                if selected_item
                  selected_item += 1
                else
                  selected_item = 0
                end
              else Audio::Sound::beep
              end

              # Reset if scrolled beyond items
              selected_item = nil if selected_item and (selected_item < 0 || selected_item >= items.count)
            end

          else
            Audio::Sound::beep
          end
        end
        window.close

        return picked_item
      end
    end
  end
end


