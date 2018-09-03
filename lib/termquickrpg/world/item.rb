require "termquickrpg/world/locatable"
require "termquickrpg/world/drawable"
require "termquickrpg/world/effect"

module TermQuickRPG
  module World
    class Item
      include Locatable
      include Drawable
      attr_reader :name, :effect

      def initialize(location: [-1,-1], char: "", name: "", effect: Effect.none)
        @x, @y = location
        @char, @name, @effect = char, name, Effect.new(effect)
      end

      def apply(entity)
        if effect
          effect.message(self, entity)
        end
      end
    end
  end
end
