require "termquickrpg/loading/map_loader"

module TermQuickRPG
  module Script
    module MapCommands
      attr_reader :game_dir

      def open_map(filename)
        raise "Required #{self.class.name}#game_dir to be set to load maps" unless game_dir
        map = Loading::MapLoader.new(File.join(game_dir, filename)).map
        Control::MapStack.instance.push(map)
      end

      def leave_map
        Control::MapStack.instance.pop
      end

      def current_map
        Control::MapStack.instance.front
      end

      def map_flags
        current_map.flags
      end

      def replace_tile(location, char)
        current_map.replace_tile(location, char)
      end
    end
  end
end
