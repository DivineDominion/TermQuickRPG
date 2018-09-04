require "termquickrpg/ui/dialogs"

module TermQuickRPG
  module UI
    class InventoryScreen
      attr_reader :items

      def initialize(items)
        @items = items
      end

      def show_picker(title = nil)
        title ||= "Inventory"
        item_labels = items.map { |item| "#{item.char}   #{item.name}" }
        choice = UI::show_options(title, [*item_labels, "Cancel"], :single)
        return (choice < item_labels.count) ? items[choice] : nil
      end
    end
  end
end