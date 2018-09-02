require "termquickrpg/world/positionable"
require "termquickrpg/ui/map_view"
require "termquickrpg/world/effect"

module TermQuickRPG
  module World
    class Item
      include Positionable
      attr_reader :char, :name, :effect

      def initialize(x, y, char, name, effect = Effect.none)
        @x, @y = x, y
        @char, @name, @effect = char, name, Effect.new(effect)
      end

      def draw(canvas, offset_x, offset_y)
        canvas.draw("#{@char}", @x + offset_x, @y + offset_y)
      end

      def apply(entity)
        if effect
          effect.message(self, entity)
        end
      end
    end
  end
end
