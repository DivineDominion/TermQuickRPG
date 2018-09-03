require "termquickrpg/world/map"
require "termquickrpg/world/character"
require "termquickrpg/world/item"

module TermQuickRPG
  module Loading
    class MapLoader
      include World

      attr_reader :path

      def initialize(path)
        @path = path
      end

      def map
        @map ||= load_map(read_map_data(@path))
      end

      def read_map_data(path)
        content = File.read(path)
        eval(content)
      rescue Errno::ENOENT => e
        raise "Could not read map file from path: #{e}"
      rescue Exception => e
        raise "Could not evaluate map data: #{e}"
      end

      def load_map(data)
        player_position = data[:player_position] || [1,1]
        player_character = Character.new(*player_position, PLAYER_CHARACTER)

        entities = []
        # entities << Item.new(8, 6, "♥", "Heart", "%s healed %s!")
        # entities << Item.new(4, 4, "¶", "Mace", "You hit with a %s!")
        entities << player_character

        Map.new(data: data, entities: entities, player_character: player_character)
      end
    end
  end
end