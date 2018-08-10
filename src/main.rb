#!/usr/bin/env ruby
#encoding: utf-8

PLAYER_CHARACTER = "☺"

class Player
  attr_reader :x, :y
  attr_reader :char
  
  def initialize
    @x = 5
    @y = 5
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

player = Player.new

require 'curses'

DIRECTIONS = {
  "w" => :up,
  "s" => :down,
  "a" => :left,
  "d" => :right,
  Curses::Key::UP => :up,
  Curses::Key::DOWN => :down,
  Curses::Key::LEFT => :left,
  Curses::Key::RIGHT => :right
}

Curses.init_screen
Curses.cbreak
Curses.curs_set(0)  # Invisible cursor
Curses.noecho # Do not print keyboard input

Curses.setpos(Curses.lines - 1, 0)
Curses.addstr("TerminalQuickRPG")
Curses.refresh

begin
  
  win = Curses::Window.new(Curses.lines - 3, Curses.cols - 2, 1, 1)
  win.box(?|, ?-)
  win.setpos(2, 2)
  win.addstr("The mighty Adventure Begins ...")
  win.keypad(true)
  player.draw(win)
  win.refresh
  
  quit = false
  while !quit
    input = win.get_char
    
    case input
    when "q", Curses::Key::EXIT, Curses::Key::CANCEL, Curses::Key::BREAK
      quit = true
      
    when -> (c) { DIRECTIONS.keys.include?(c) }
      old_y, old_x = [player.y, player.x]
      
      win.setpos(old_y, old_x)
      win.addstr(" ")

      player.move(DIRECTIONS[input])
      player.draw(win)
    end
    
    win.refresh
  end
  Curses.close_screen
  puts "Bye!"
rescue => ex
  Curses.close_screen
  raise ex
end