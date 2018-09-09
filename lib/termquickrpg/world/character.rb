require "termquickrpg/world/locatable"
require "termquickrpg/world/locomotive"
require "termquickrpg/world/drawable"
require "termquickrpg/ui/color"

PLAYER_CHARACTER = "☻"
PLAYER_COLOR = TermQuickRPG::UI::Color::Pair::PLAYER

module TermQuickRPG
  module World
    class Character
      include Locatable
      include Locomotive
      include Drawable

      def initialize(location: [-1,-1], char: nil, name: nil, color: UI::Color::Pair::DEFAULT, talk: nil)
        @x, @y = location
        @char = char
        @name, @talk = name, talk
        @color = color
      end
    end
  end
end
