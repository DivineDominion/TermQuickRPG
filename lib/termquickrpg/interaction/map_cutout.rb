module TermQuickRPG
  module Interaction
    class MapCutout
      attr_reader :map, :origin, :size

      def initialize(map, origin, size)
        @map, @origin, @size = map, origin, size
      end

      def draw(canvas)
        map.draw(canvas, *origin, *size)
      end
    end
  end
end
