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
        { id: File.basename(path) }.merge(eval(content))
      rescue Errno::ENOENT => e
        raise "Could not read map file from path: #{e}"
      rescue Exception => e
        raise "Could not evaluate map data: #{e}"
      end

      def load_map(data)
        player_position = data[:player_position] || [1,1]
        player_character = Character.new(location: player_position, char: PLAYER_CHARACTER, name: "You", color: PLAYER_COLOR)

        Map.new(data: data, player_character: player_character)
      end
    end
  end
end
