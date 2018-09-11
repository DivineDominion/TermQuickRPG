require "termquickrpg/control/window_registry"

module TermQuickRPG
  module Inventory
    class InventoryWindow
      TITLE = "Inventory"

      attr_reader :title, :style
      attr_accessor :items

      def initialize(items = [])
        @style = :double
        @items = items
      end

      def window
        @window ||= Control::WindowRegistry.instance.create_bordered_window(
          style: @style,
          centered: [:horizontal, :vertical], height: 15, width: 35)
      end

      def customize_title(title = nil)
        @title = title || TITLE
      end

      def close
        unless @window.nil? # Do not lazily create new on close
          @window.close
          @window = nil
        end
      end

      def draw(selected_item: nil)
        window.draw do |frame, border, content|
          draw_title(content)
          draw_divider(border, 2)
          draw_items(content, selected_item)
          draw_divider(border, border.height - 3)
          draw_buttons(content, selected_item == nil)
        end
      end

      private

      def draw_title(content)
        x = (content.width - title.length) / 2
        content.setpos(0, x)
        content.addstr(title)
      end

      def draw_divider(border, y)
        border.draw_divider(style, y)
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