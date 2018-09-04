require "termquickrpg/observable"

module TermQuickRPG
  module World
    module Locomotive
      include Observable

      attr_reader :x, :y

      def can_move?(map, dir)
        x, y = project_movement(dir)
        map.include?(x, y) && !map.blocked?(x, y)
      end

      def move(dir)
        old_x, old_y = x, y
        @x, @y = project_movement(dir)
      ensure
        notify_listeners(:character_did_move, [old_x, old_y], [@x, @y])
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
    end
  end
end