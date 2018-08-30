require_relative "map_view.rb"

module TermQuickRPG
  class Item
    attr_reader :x, :y, :name

    def initialize(x, y, char, name)
      @x, @y, @char, @name = x, y, char, name
    end

    def draw(canvas, offset_x, offset_y)
      canvas.draw("#{@char}", @x + offset_x, @y + offset_y)
    end
  end
end
