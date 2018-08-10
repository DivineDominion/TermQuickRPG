PLAYER_CHARACTER = "☺"

class Player
  attr_reader :x, :y
  attr_reader :char
  
  def initialize(x, y)
    @x = x
    @y = y
    @char = PLAYER_CHARACTER
  end
  
  def move(dir)
    @y = case dir
         when :up then   @y -= 1
         when :down then @y += 1
         else            @y
         end
    @x = case dir
         when :left then  @x -= 1
         when :right then @x += 1
         else             @x
         end
    [@x, @y]
  end
  
  def draw(win)
    old_y, old_x = [win.cury, win.curx]
    win.setpos(@y, @x)
    win.addstr("#{@char}")
    win.setpos(old_y, old_x)
  end
end
