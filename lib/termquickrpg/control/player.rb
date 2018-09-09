require "singleton"
require "termquickrpg/inventory"
require "termquickrpg/audio/sounds"

module TermQuickRPG
  module Control
    class Player
      include Singleton

      attr_reader :character

      def inventory
        @inventory ||= Inventory::Inventory.new
      end

      def item_from_inventory(reason = nil)
        inventory.pick_item(reason)
      end

      def take(item)
        inventory << item
      end

      def remove_from_inventory(item)
        inventory.remove(item)
      end

      def switch_control(character)
        @character = character
      end

      def name
        "You"
      end

      def move(map, direction)
        return unless character.can_move?(map, direction)

        character.move(direction)

        if trigger = usable_trigger(map)
          trigger.execute(Script::Context.main)
        end
      end

      def usable_trigger(map)
        map.trigger(character.location)
      end

      def interact(map)
        if obj = usable_entity(map)
          if obj.is_a?(World::Item)
            choice = UI::show_options("Found #{obj.name}!", { pick: "Pick up", cancel: "Leave" }, :single)

            if choice == :pick
              map.entities.delete(obj)
              take(obj)
            end
          elsif obj.is_a?(World::Character)
            obj.talk_to(Script::Context.main)
          end
        elsif interaction = usable_interaction(map)
          interaction.execute(Script::Context.main)
        else
          Audio::Sound::beep
        end
      end

      def usable_entity(map)
        map.entity_under(character)
      end

      def usable_interaction(map)
        map.interaction(character.location)
      end
    end
  end
end
