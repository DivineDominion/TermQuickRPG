class Item
  attr_reader :x, :y, :name
  
  def initialize(x, y, char, name)
    @x, @y, @char, @name = x, y, char, name
  end

  def draw(win)
    old_y, old_x = [win.cury, win.curx]
    win.setpos(@y, @x)
    win.addstr("#{@char}")
    win.setpos(old_y, old_x)
  end
end