require "termquickrpg/world/locatable"
require "termquickrpg/world/locomotive"
require "termquickrpg/world/drawable"
require "termquickrpg/ui/colors"

PLAYER_CHARACTER = "☺"
PLAYER_COLOR = TermQuickRPG::UI::Color::Pair::PLAYER

module TermQuickRPG
  module World
    class Character
      include Locatable
      include Locomotive
      include Drawable

      def initialize(x, y, char, color = UI::Color::Pair::DEFAULT)
        @x, @y = x, y
        @char = char
        @color = color
      end
    end
  end
end
