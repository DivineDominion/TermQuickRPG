#!/usr/bin/env ruby
#encoding: utf-8

require 'curses'
require_relative "player.rb"

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
Curses.addstr("TerminalQuickRPG by DivineDominion / 2018")
Curses.refresh

begin
  
  win = Curses::Window.new(Curses.lines - 3, Curses.cols - 2, 1, 1)
  win.box(?|, ?-)
  win.keypad(true) # enable arrow keys

  win.setpos(2, 2)
  win.addstr("The mighty Adventure Begins ...")
  
  player = Player.new(5,5)
  player.draw(win)
  
  quit = false
  while !quit
    win.refresh
    
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
  end
  
  Curses.close_screen
  
  puts "Bye!"
rescue => ex
  Curses.close_screen
  raise ex
end
