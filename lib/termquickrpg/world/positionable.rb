module TermQuickRPG
  module World
    module Positionable
      attr_reader :x, :y

      def location
        [x, y]
      end

      def is_contained_in(x_off, y_off, width, height)
        return x >= x_off && x < x_off + width \
            && y >= y_off && y < y_off + height
      end
    end
  end
end