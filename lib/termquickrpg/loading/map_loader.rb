require "termquickrpg/world/map"
require "termquickrpg/world/player"
require "termquickrpg/world/item"

module TermQuickRPG
  module Loading
    class MapLoader
      include World

      def load_map(data)
        player_position = data[:player_position] || [1,1]
        player = Player.new(*player_position)

        entities = []
        entities << Item.new(8, 6, "♥", "Heart", "%s healed %s!")
        entities << Item.new(4, 4, "¶", "Mace", "You hit with a %s!")
        entities << player

        map = Map.new(data: data, entities: entities)

        [map, player]
      end
    end
  end
end