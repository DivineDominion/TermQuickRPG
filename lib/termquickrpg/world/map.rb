module TermQuickRPG
  module World
    class Map
      attr_reader :width, :height
      attr_reader :entities

      def initialize(width, height, entities)
        @width, @height = width, height
        @entities = entities
      end

      def contains(x, y)
        x >= 0 && y >= 0 && x < width && y < height
      end

      def draw(canvas, start_x, start_y, width, height)
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
