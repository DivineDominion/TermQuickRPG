require "termquickrpg/world/layer"
require "termquickrpg/world/trigger"

module TermQuickRPG
  module World
    class Map
      attr_reader :width, :height
      attr_reader :layers
      attr_reader :entities, :player_character
      attr_reader :triggers

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
        @player_character = opts[:player_character]
        @triggers = opts[:data][:triggers].map { |loc, proc| [loc, Trigger.new(loc, proc)] }.to_h
      end

      attr_writer :active

      def active?
        @active || false
      end

      # Movable contents

      def blocked?(x, y)
        return false unless @collisions
        @collisions[y] && @collisions[y][x]
      end

      def include?(x, y)
        x >= 0 && y >= 0 && x < width && y < height
      end

      def entity_under(object)
        entities.each do |entity|
          next if entity == object
          if entity.location == object.location
            return entity
          end
        end

        nil
      end

      def trigger(location)
        triggers[location]
      end

      # Drawing

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
