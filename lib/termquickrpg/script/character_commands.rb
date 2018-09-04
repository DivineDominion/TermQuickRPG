require "termquickrpg/world/character"

module TermQuickRPG
  module Script
    module CharacterCommands
      def player
        current_map.player_character
      end

      def move(character, direction, after_delay = 0.5)
        sleep after_delay
        character.move(direction)
      end
    end
  end
end
