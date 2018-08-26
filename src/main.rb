#!/usr/bin/env ruby
#encoding: utf-8

require "curses"
require_relative "player.rb"
require_relative "item.rb"
require_relative "dialogs.rb"
require_relative "map.rb"
require_relative "map_view.rb"

DIRECTION_KEYS = {
  ?w => :up,
  ?s => :down,
  ?a => :left,
  ?d => :right,
  Curses::Key::UP => :up,
  Curses::Key::DOWN => :down,
  Curses::Key::LEFT => :left,
  Curses::Key::RIGHT => :right
}

ACTION_KEYS = {
  ?e => :use,
  " " => :use,
  Curses::Key::ENTER => :use,
}

Curses.init_screen
Curses.start_color
Curses.stdscr.keypad(true) # enable arrow keys
Curses.cbreak # no line buffering / immediate key input
Curses.ESCDELAY = 0
Curses.curs_set(0)  # Invisible cursor
Curses.noecho # Do not print keyboard input

# Spiffy game title
TITLE = "TerminalQuickRPG by DivineDominion / 2018"
Curses.setpos(Curses.lines - 1, (Curses.cols - TITLE.length) / 2)
Curses.addstr(TITLE)
Curses.refresh

player = Player.new(5,5)

ENTITIES = "The Adventure Begins ...".split("").map.with_index { |c, i| Item.new(2 + i, 2, c, c) }
ENTITIES.delete_if { |e| e.name == " " }
ENTITIES << Item.new(8, 6, "♥", "Heart")
ENTITIES << Item.new(4, 4, "¶", "Mace")
ENTITIES << player

class Hash
  # case matching
  def ===(element)
    self.has_key?(element)
  end
end

BORDERS_WIDTH = 2
begin
  map = Map.new(Curses.cols - 2 - BORDERS_WIDTH, Curses.lines - 3 - BORDERS_WIDTH)
  map_view = MapView.new(map, 1, 1)
  win = map_view.window
  win.box(?|, ?-)
  win.keypad(true)

  draw_entities = -> do
    ENTITIES.each { |e| e.draw(map_view) }
  end

  redraw_window = -> do
    win.clear
    win.box(?|, ?-)
    draw_entities.call
    win.refresh
  end

  draw_entities.call

  quit = false
  while !quit
    win.refresh

    input = win.get_char

    case input
    when "q", "\e", Curses::Key::EXIT, Curses::Key::CANCEL, Curses::Key::BREAK
      quit = true # faster during dev
      # case show_options("Quit?", { yes: "Yes", cancel: "No" }, :double)
      # when :yes then quit = true
      # else redraw_window.call
      # end

    when DIRECTION_KEYS
      direction = DIRECTION_KEYS[input]
      old_x, old_y = player.x, player.y

      if obj = player.would_collide_with(ENTITIES, direction)
        choice = show_options("Found #{obj.name}!", { pick: "Pick up", cancel: "Leave" }, :single)

        if choice == :pick
          ENTITIES.delete(obj)
          player.move(direction)
        end

        redraw_window.call
      elsif player.would_fit_into_map(map, direction)
        player.move(direction)
      end

      map_view.undraw(old_x, old_y)
      player.draw(map_view)

    when ACTION_KEYS
      action = ACTION_KEYS[input]

      show_message("Cannot interact with anything here.")
      redraw_window.call

    else
      show_message("got #{input} / #{input.ord}")
      redraw_window.call
    end
  end

  Curses.close_screen

  puts "Bye!"
rescue => ex
  Curses.close_screen
  raise ex
end
