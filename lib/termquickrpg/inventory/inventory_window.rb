require "delegate"
require "termquickrpg/control/window_registry"
require "termquickrpg/inventory/inventory_view"

module TermQuickRPG
  module Inventory
    class InventoryWindow < SimpleDelegator
      attr_accessor :inventory_view

      def initialize
        super(Control::WindowRegistry.create_bordered_window(
          style: @style,
          centered: [:horizontal, :vertical], height: 15, width: 35))
        @inventory_view = InventoryView.new([])
        self.add_subview(@inventory_view)
      end

      def items=(items)
        inventory_view.items = items
      end

      def customize_title(title = nil)
        inventory_view.customize_title(title)
      end

      def select_item(item)
        inventory_view.selected_item = item
      end
    end
  end
end
