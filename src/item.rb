class Item
  attr_reader :x, :y
  
  def initialize(x, y, char)
    @x = x
    @y = y
    @char = char
  end

  def draw(win)
    old_y, old_x = [win.cury, win.curx]
    win.setpos(@y, @x)
    win.addstr("#{@char}")
    win.setpos(old_y, old_x)
  end
end