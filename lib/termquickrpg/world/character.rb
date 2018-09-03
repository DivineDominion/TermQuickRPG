require "termquickrpg/world/locatable"
require "termquickrpg/world/locomotive"
require "termquickrpg/world/drawable"

PLAYER_CHARACTER = "☺"

module TermQuickRPG
  module World
    class Character
      include Locatable
      include Locomotive
      include Drawable

      def initialize(x, y, char)
        @x, @y = x, y
        @char = char
      end

      def trigger(map)
        map.trigger(location)
      end
    end
  end
end
