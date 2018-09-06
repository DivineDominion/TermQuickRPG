require "termquickrpg/ui/inventory_screen"

module TermQuickRPG
  module Control
    class Inventory
      attr_reader :items

      def initialize(items = [])
        @items = items
      end

      def <<(item)
        items << item
      end

      def remove(item)
        items.delete(item)
      end

      def pick_item(reason = nil)
        UI::InventoryScreen.new(items).show_picker(reason)
      end
    end
  end
end