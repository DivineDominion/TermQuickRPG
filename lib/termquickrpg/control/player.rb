require "singleton"
require "termquickrpg/control/inventory"

module TermQuickRPG
  module Control
    class Player
      include Singleton

      attr_reader :character

      def inventory
        @inventory ||= Inventory.new
      end

      def item_from_inventory(reason = nil)
        inventory.pick_item(reason)
      end

      def switch_control(character)
        @character = character
      end

      def name
        "You"
      end

      def take(item)
        inventory << item
      end

      def move(map, direction)
        return unless character.can_move?(map, direction)

        character.move(direction)

        if trigger = character.trigger(map)
          trigger.execute
        end
      end

      def usable_entity(map)
        map.entity_under(character)
      end
    end
  end
end
