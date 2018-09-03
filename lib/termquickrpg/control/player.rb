module TermQuickRPG
  module Control
    class Player
      attr_reader :character
      attr_reader :inventory

      def initialize(character = nil, inventory = [])
        @character = character
        @inventory = inventory
      end

      def switch_control(character)
        @character = character
      end

      def name
        "You"
      end

      def take(item)
        @inventory << item
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
