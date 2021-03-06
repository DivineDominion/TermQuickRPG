require "termquickrpg/world/layer"
require "termquickrpg/world/item"
require "termquickrpg/world/hot_spot"
require "termquickrpg/observable"

module TermQuickRPG
  module World
    class Map
      include Observable

      attr_reader :id
      attr_reader :width, :height
      attr_reader :layers
      attr_reader :entities, :player_character
      attr_reader :triggers, :interactions
      attr_reader :flags
      attr_reader :collisions, :solid_tiles

      def initialize(**opts)
        raise "Map is missing :data" unless opts[:data]
        data = opts[:data]
        raise "Map data is missing :id" unless data[:id]
        raise "Map data is missing :size" unless data[:size]
        raise "Map data is missing :layers" unless data[:layers] && !data[:layers].empty?

        @id = data[:id]

        data = {
          items: [],
          characters: [],
          flags: {},
          triggers: {},
          interactions: {}
        }.merge(data)

        @width, @height = data[:size]

        map_width, map_height = layer_size(data[:layers][0])
        raise "Map size #{@width}x#{@height} does not equal base layer size #{map_width}x#{map_height}" if @width != map_width || @height != map_height

        @layers = data[:layers].map { |l| Layer.new(l) }
        @solid_tiles = data[:solids]
        update_collisions

        @flags = data[:flags]

        @player_character = opts[:player_character]
        @items = data[:items].map { |e| Item.new(e) } || []
        @characters = data[:characters].map { |e| Character.new(e) } || []
        @entities = [*@items, *@characters, @player_character] # Draw player on top
        @player_character.add_listener(self)

        @triggers = data[:triggers].map { |loc, proc| [loc, HotSpot.new(loc, proc)] }.to_h
        @interactions = data[:interactions].map { |loc, proc| [loc, HotSpot.new(loc, proc)] }.to_h
      end

      def update_collisions
        @collisions = @layers[0].blocked_tiles(solid_tiles)
      end

      def replace_tile(location, char)
        z = location[2] || 0
        layers[z].replace_tile(location, char)
        update_collisions if z == 0
        invalidate!
      end

      def invalidate!
        notify_listeners(:map_content_did_invalidate, true) # redraw map
      end

      def character_did_move(character, from, to)
        invalidate!
      end

      def layer_size(layer)
        width = layer.map { |line| line.length }.max
        height = layer.length
        [width, height]
      end

      def active=(value)
        @active = value
      end

      def active?
        @active || false
      end

      # Movable contents

      def blocked?(x, y)
        has_solid_block?(x, y) || has_character_at?(x, y)
      end

      def has_solid_block?(x, y)
        return false unless collisions
        collisions[y] && collisions[y][x]
      end

      def has_character_at?(x, y)
        return false unless @characters
        @characters.find { |c| c.location == [x, y] }
      end

      def include?(x, y)
        x >= 0 && y >= 0 && x < width && y < height
      end

      def entity_at(obj)
        location = obj.respond_to?(:location) ? obj.location : obj
        entities.each do |entity|
          if entity.location == location
            return entity
          end
        end

        nil
      end

      def interaction_at(obj)
        location = obj.respond_to?(:location) ? obj.location : obj
        matches = interactions.keys.find_all { |hsloc| hot_spot_location_include?(hsloc, location) }
        if matches
          raise "Overlapping interactions not implemented" if matches.count > 1
          interactions[matches.first]
        end
      end

      def trigger(location)
        matches = triggers.keys.find_all { |loc| hot_spot_location_include?(loc, location) }
        if matches
          raise "Overlapping triggers not implemented" if matches.count > 1
          triggers[matches.first]
        end
      end

      def hot_spot_location_include?(hot_spot_location, location)
        x1,y1 = hot_spot_location
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
