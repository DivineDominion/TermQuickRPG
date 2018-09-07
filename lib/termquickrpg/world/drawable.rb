module TermQuickRPG
  module World
    module Drawable
      attr_reader :x, :y, :char, :color

      def draw(canvas, offset_x, offset_y)
        canvas.draw("#{char}", x + offset_x, y + offset_y, color)
      end
    end
  end
end
