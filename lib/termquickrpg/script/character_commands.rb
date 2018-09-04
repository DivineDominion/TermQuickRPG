require "termquickrpg/world/character"

module TermQuickRPG
  module Script
    module CharacterCommands
      def player
        current_map.player_character
      end

      def move(character, direction, after_delay = 0)
        sleep(after_delay) if after_delay > 0
        character.move(direction)
      end
    end
  end
end
