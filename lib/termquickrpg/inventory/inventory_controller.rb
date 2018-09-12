require "termquickrpg/inventory/inventory_window"
require "termquickrpg/control/default_keys"

module TermQuickRPG
  module Inventory
    class InventoryController
      def show_picker(items, title = nil, window = InventoryWindow.new)
        picker = Picker.new(items)
        window.items = items
        window.customize_title(title) # `nil` shows default
        window.select_item(picker.selected_item)

        while !picker.picked_item && !picker.did_cancel do
          Control::WindowRegistry.instance.render_window_stack

          picker.handle_input do |selected_item|
            window.select_item(selected_item)
          end
        end
        window.close

        return picker.picked_item
      end

      private

      class Picker
        attr_reader :items
        attr_reader :selected_item, :picked_item, :did_cancel

        def initialize(items)
          @items = items
          # Select "Cancel" on empty inventory or first item
          @selected_item = items.empty? ? nil : 0
        end

        def handle_input
          input = Curses.get_char
          case input
          when Control::ACTION_KEYS
            if Control::ACTION_KEYS[input] == :use
              if selected_item
                @picked_item = items[selected_item]
              else
                @did_cancel = true
              end
            else
              Audio::Sound::beep
            end

          when Control::CANCEL_KEYS # Cancel or quit will close
            @did_cancel = true

          when Control::DIRECTION_KEYS
            if items.empty?
              Audio::Sound::beep
            else
              case Control::DIRECTION_KEYS[input]
              when :up
                if selected_item
                  @selected_item -= 1
                else
                  @selected_item = items.count - 1
                end
              when :down
                if selected_item
                  @selected_item += 1
                else
                  @selected_item = 0
                end
              else Audio::Sound::beep
              end

              # Reset if scrolled beyond items
              @selected_item = nil if @selected_item and (@selected_item < 0 || @selected_item >= items.count)

              yield @selected_item
            end

          else
            Audio::Sound::beep
          end
        end
      end
    end
  end
end


