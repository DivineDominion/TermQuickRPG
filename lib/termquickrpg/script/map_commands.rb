require "termquickrpg/loading/map_loader"

module TermQuickRPG
  module Script
    module MapCommands
      attr_reader :game_dir

      def open_map(filename)
        raise "Required #{self.class.name}#game_dir to be set to load maps" unless game_dir
        loader = Loading::MapLoader.new(File.join(game_dir, filename))
        loader.map
      end

      def leave_map
        `say "Leave map"`
      end
    end
  end
end
