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

      attr_accessor :name, :char
      attr_reader :talk

      def initialize(location: [-1,-1], char: nil, name: nil, color: UI::Color::Pair::DEFAULT, talk: nil)
        @x, @y = location
        @char = char
        @name, @talk = name, talk
        @color = color
      end

      def change_name(new_name)
        @name = new_name
      end

      def replace_char(new_char)
        @char = new_char
      end

      def talk_to(context)
        return unless talk
        context.call_block(talk, self)
      end
    end
  end
end
