class Map
  attr_reader :width, :height

  def initialize(width, height)
    @width, @height = width, height
  end

  def contains(x, y)
    x >= 0 && y >= 0 && x < width && y < height
  end
end
