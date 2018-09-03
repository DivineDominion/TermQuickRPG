require "termquickrpg/world/layer"
require "termquickrpg/world/item"
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
        raise "Map data is missing :layers" unless opts[:data][:layers] && !opts[:data][:layers].empty?

        opts[:data] = {
          items: []
        }.merge(opts[:data])

        @width, @height = opts[:data][:size]

        map_width, map_height = layer_size(opts[:data][:layers][0])
        raise "Map size #{@width}x#{@height} does not equal base layer size #{map_width}x#{map_height}" if @width != map_width || @height != map_height

        @layers = opts[:data][:layers].map { |l| Layer.new(l) }
        @collisions = @layers[0].blocked_tiles(opts[:data][:solids])

        @player_character = opts[:player_character]
        @entities = opts[:data][:items].map { |e| Item.new(e) } || []
        @entities << @player_character

        @triggers = opts[:data][:triggers].map { |loc, proc| [loc, Trigger.new(loc, proc)] }.to_h
      end

      def layer_size(layer)
        width = layer.map { |line| line.length }.max
        height = layer.length
        [width, height]
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
        matches = triggers.keys.find_all { |loc| trigger_location_include?(loc, location) }
        if matches
          raise "Overlapping triggers not implemented" if matches.count > 1
          triggers[matches.first]
        end
      end

      def trigger_location_include?(trigger_location, location)
        x1,y1 = trigger_location
        x2,y2 = location
        return (x1.respond_to?(:include?) ? x1.include?(x2) : x1 == x2) \
            && (y1.respond_to?(:include?) ? y1.include?(y2) : y1 == y2)
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
