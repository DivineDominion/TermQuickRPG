module TermQuickRPG
  module World
    class Map
      attr_reader :width, :height
      attr_reader :entities

      def initialize(**opts)
        raise "Map is missing :data" unless opts[:data]
        raise "Map data is missing :size" unless opts[:data][:size]
        raise "Map data is missing :layers" unless opts[:data][:layers]

        @width, @height = opts[:data][:size]
        @layers = opts[:data][:layers]
        @entities = opts[:entities] || []
      end

      def contains(x, y)
        x >= 0 && y >= 0 && x < width && y < height
      end

      def draw(canvas, start_x, start_y, width, height)
        draw_layer(@layers[0], canvas, start_x, start_y, width, height)
        draw_entities(canvas, start_x, start_y, width, height)
        draw_layer(@layers[1], canvas, start_x, start_y, width, height)
      end

      def draw_layer(layer, canvas, start_x, start_y, width, height)
        return if layer.nil?

        end_x = start_x + width
        end_y = start_y + height

        layer
          .select.with_index { |line, y| start_x <= y && y <= end_y }
          .map { |line| line[start_x ... end_x] }
          .each.with_index { |l, y|
            l.chars.each.with_index { |char, x| canvas.draw(char, x, y) unless char == " " } }
      end

      def draw_entities(canvas, start_x, start_y, width, height)
        @entities
          .select { |e| entity_is_visible(e, start_x, start_y, width, height) }
          .each { |e| e.draw(canvas, -start_x, -start_y) }
      end

      def entity_is_visible(entity, start_x, start_y, width, height)
        return entity.x >= start_x && entity.x < start_x + width \
            && entity.y >= start_y && entity.y < start_y + height
      end
    end
  end
end
