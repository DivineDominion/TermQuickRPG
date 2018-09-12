require "termquickrpg/ui/view"

module TermQuickRPG
  module Inventory
    class InventoryView
      include UI::View

      TITLE = "Inventory"

      attr_reader :title
      attr_accessor :items, :selected_item

      def initialize(items = [])
        @items = items
      end

      def customize_title(title = nil)
        @title = title || TITLE
      end

      def border
        superview.border
      end

      def render(border_window: nil, canvas: nil, **opts)
        raise unless border_window && canvas
        draw_title(canvas)
        draw_divider(border_window, 2)
        draw_items(canvas, selected_item)
        draw_divider(border_window, border_window.height - 3)
        draw_buttons(canvas, selected_item == nil)
      end

      private

      def draw_title(content)
        x = (content.width - title.length) / 2
        content.setpos(0, x)
        content.addstr(title)
      end

      def draw_divider(border_window, y)
        border_window.draw_divider(y)
      end

      def draw_items(content, selected_item)
        if items.empty?
          label = "Empty"
          width, height = content.width, content.height - 2 # Dividers
          x = (width - label.length) / 2
          y = height / 2
          content.setpos(y, x)
          content.addstr(label)
        else
          offset_y = 2
          offset_x = 2
          items.each.with_index do |item, index|
            y = offset_y + index
            content.with_attrs(selected_item == index ? Curses::A_STANDOUT : []) do
              content.setpos(y, offset_x)
              content.addstr("#{item.char}   #{item.name}")
            end
          end
        end
      end

      def draw_buttons(content, is_selected = false)
        cancel_button = "[Cancel]"
        x = (content.width - cancel_button.length) / 2
        content.with_attrs(is_selected ? Curses::A_STANDOUT : []) do
          content.setpos(content.height - 1, x)
          content.addstr(cancel_button)
        end
      end
    end
  end
end
