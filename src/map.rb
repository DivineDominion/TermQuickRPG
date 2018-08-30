class Map
  attr_reader :width, :height
  attr_reader :entities

  def initialize(width, height, entities)
    @width, @height = width, height
    @entities = entities
  end

  def contains(x, y)
    x >= 0 && y >= 0 && x < width && y < height
  end

  def draw(canvas)
    @entities.each { |e| e.draw(canvas) }
  end
end
