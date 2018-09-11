require "termquickrpg/interaction/target_window"

module TermQuickRPG
  module Interaction
    class TargetController
      attr_reader :window, :size
      attr_accessor :target_offset

      def initialize(size, start_offset, window)
        @size = size
        @target_offset = start_offset
        @window = window
      end

      def center
        width, height = size
        [0 + width/2, 0 + height/2]
      end

      def reset_target
        change_offset(center)
      end

      def move_picker(direction)
        change_offset(translated_picker_offset(direction))
      end

      def draw_picker
        window.draw
      end

      def close_window
        window.close
        @window = nil
      end

      private

      def change_offset(new_offset)
        @target_offset = new_offset
        window.target_offset = new_offset
      end

      def translated_picker_offset(direction)
        x, y = target_offset
        width, height = size
        diff_x, diff_y = case direction
                         when :up then    [0, -1]
                         when :down then  [0,  1]
                         when :left then  [-1, 0]
                         when :right then [1,  0]
                         else [0 ,0]
                         end
        new_x, new_y = x + diff_x, y + diff_y
        x = (0 ... width).include?(new_x) ? new_x : x
        y = (0 ... height).include?(new_y) ? new_y : y
        [x, y]
      end
    end
  end
end
