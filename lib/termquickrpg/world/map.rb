require "termquickrpg/world/layer"

module TermQuickRPG
  module World
    class Map
      attr_reader :width, :height
      attr_reader :layers
      attr_reader :entities

      def initialize(**opts)
        raise "Map is missing :data" unless opts[:data]
        raise "Map data is missing :size" unless opts[:data][:size]
        raise "Map data is missing :layers" unless opts[:data][:layers]

        @width, @height = opts[:data][:size]

        map_width, map_height = opts[:data][:layers][0].map { |line| line.length}.max, opts[:data][:layers][0].length
        raise "Map size #{@width}x#{@height} does not equal base layer size #{map_width}x#{map_height}" if @width != map_width || @height != map_height

        @layers = opts[:data][:layers].map { |l| Layer.new(l) }
        @collisions = @layers[0].blocked_tiles(opts[:data][:solids])
        @entities = opts[:entities] || []
      end

      def contains(x, y)
        x >= 0 && y >= 0 && x < width && y < height
      end

      def blocked?(x, y)
        return false unless @collisions
        @collisions[y][x]
      end

      def draw(canvas, start_x, start_y, width, height)
        draw_layer(layers[0], canvas, start_x, start_y, width, height)
        draw_entities(canvas, start_x, start_y, width, height)
        draw_layer(layers[1], canvas, start_x, start_y, width, height)
      end

      def draw_layer(layer, canvas, start_x, start_y, width, height)
        return if layer.nil?
        layer.cutout(start_x, start_y, width, height).draw(canvas)
      end

      def draw_entities(canvas, start_x, start_y, width, height)
        @entities
          .select { |e| e.is_contained_in(start_x, start_y, width, height) }
          .each { |e| e.draw(canvas, -start_x, -start_y) }
      end
    end
  end
end
