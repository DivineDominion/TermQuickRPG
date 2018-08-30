require_relative "map_view.rb"

class Item
  attr_reader :x, :y, :name

  def initialize(x, y, char, name)
    @x, @y, @char, @name = x, y, char, name
  end

  def draw(canvas)
    canvas.draw("#{@char}", @x, @y)
  end
end
