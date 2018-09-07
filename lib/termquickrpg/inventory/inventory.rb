require "termquickrpg/inventory/inventory_controller"

module TermQuickRPG
  module Inventory
    class Inventory
      attr_reader :items

      def initialize(items = [])
        @items = items
      end

      def inventory_controller
        @controller ||= InventoryController.new
      end

      def <<(item)
        items << item
      end

      def remove(item)
        items.delete(item)
      end

      def pick_item(reason = nil)
        inventory_controller.show_picker(items, reason)
      end
    end
  end
end
