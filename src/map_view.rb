require "curses"

class MapView
  attr_reader :offset_x, :offset_y
  attr_reader :map
  attr_reader :window

  def initialize(map, offset_x, offset_y)
    @offset_x, @offset_y = offset_x, offset_y
    @map = map
    @window = Curses::Window.new(map.height + 2, map.width + 2, offset_y, offset_x)
  end

  def offset(x, y)
    [x + offset_x, y + offset_y]
  end

  def draw(char, map_x, map_y)
    x, y = offset(map_x, map_y)
    old_y, old_x = [@window.cury, @window.curx]
    @window.setpos(y, x)
    @window.addstr("#{char}")
    @window.setpos(old_y, old_x)
  end

  def undraw(map_x, map_y)
    draw(" ", map_x, map_y)
  end
end
