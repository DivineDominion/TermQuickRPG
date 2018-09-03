require "termquickrpg/world/positionable"
require "termquickrpg/observable"

PLAYER_CHARACTER = "☺"

module TermQuickRPG
  module World
    class Player
      include Observable
      PLAYER_DID_MOVE = :player_did_move

      include Positionable
      attr_reader :char
      attr_reader :inventory

      def initialize(x, y)
        @x = x
        @y = y
        @char = PLAYER_CHARACTER
        @inventory = []
      end

      def name
        "You"
      end

      def take(item)
        @inventory << item
      end

      def move(dir)
        @x, @y = project_movement(dir)
        notify_listeners(PLAYER_DID_MOVE, @x, @y)
        [@x, @y]
      end

      def draw(canvas, offset_x, offset_y)
        canvas.draw("#{@char}", @x + offset_x, @y + offset_y)
      end

      def project_movement(dir)
        new_y = case dir
                when :up then   y - 1
                when :down then y + 1
                else            y
                end
        new_x = case dir
                when :left then  x - 1
                when :right then x + 1
                else             x
                end
        [new_x, new_y]
      end

      def can_move?(map, dir)
        x, y = project_movement(dir)
        map.include?(x, y) && !map.blocked?(x, y)
      end
    end
  end
end
