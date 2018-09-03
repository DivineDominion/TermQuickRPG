require "termquickrpg/runner"
require "termquickrpg/version"
require "termquickrpg/loading/map_loader"

module TermQuickRPG
  class << self
    def run(**opts)
      map_data = if opts[:path]
                   read_map_data(opts[:path])
                 else
                   opts
                 end
      map, player = load_map(map_data)
      Runner.new(map).run
    end

    def read_map_data(path)
      content = File.read(path)
      eval(content)
    end

    def load_map(data, loader = Loading::MapLoader.new)
      loader.load_map(data)
    end
  end
end
