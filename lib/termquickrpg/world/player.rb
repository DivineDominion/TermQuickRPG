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

      def project_movement(dir)
        y = case dir
            when :up then   @y - 1
            when :down then @y + 1
            else            @y
            end
        x = case dir
            when :left then  @x - 1
            when :right then @x + 1
            else             @x
            end
        [x, y]
      end

      def move(dir)
        @x, @y = project_movement(dir)
        notify_listeners(PLAYER_DID_MOVE, @x, @y)
        [@x, @y]
      end

      def draw(canvas, offset_x, offset_y)
        canvas.draw("#{@char}", @x + offset_x, @y + offset_y)
      end

      def would_fit_into_map(map, dir)
        x, y = project_movement(dir)
        map.contains(x, y)
      end

      def would_collide_with_entities(objects, dir)
        x, y = project_movement(dir)

        objects.each do |obj|
          next if obj == self
          if obj.x == x && obj.y == y
            return obj
          end
        end

        false
      end
    end
  end
end
