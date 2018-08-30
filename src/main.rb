#!/usr/bin/env ruby
#encoding: utf-8

require "curses"
require_relative "screen.rb"
require_relative "player.rb"
require_relative "item.rb"
require_relative "dialogs.rb"
require_relative "map.rb"
require_relative "map_view.rb"
require_relative "viewport.rb"

include TermQuickRPG # more conveniently use module namespace

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

begin
  screen = Screen.new
  viewport = Viewport.new(40, 8, 20, 10)
  player.add_listener(viewport)
  map = Map.new(30, 30, ENTITIES)
  map_view = MapView.new(map, viewport)
  screen.add_listener(map_view)
  map_view.window.keypad(true)

  quit = false
  while !quit
    Curses.setpos(0, 0)
    Curses.addstr(  "player pos: #{player.x}, #{player.y}")
    Curses.addstr("\nviewport at #{viewport.x}, #{viewport.y}; #{viewport.width}x#{viewport.height}, scroll: #{viewport.scroll_x}, #{viewport.scroll_y}")
    Curses.addstr("\nscr #{screen.width}x#{screen.height} 0 #{viewport.max_x},#{viewport.max_y}")

    map_view.display

    input = Curses.get_char

    case input
    when "q", "\e", Curses::Key::EXIT, Curses::Key::CANCEL, Curses::Key::BREAK
      quit = true # faster during dev
      # case show_options("Quit?", { yes: "Yes", cancel: "No" }, :double)
      # when :yes then quit = true
      # else redraw_window.call
      # end

    when "r"
      map_view.screen_size_did_change(nil, {width: 40, height: 20})

    when DIRECTION_KEYS
      direction = DIRECTION_KEYS[input]
      old_x, old_y = player.x, player.y

      if obj = player.would_collide_with(ENTITIES, direction)
        choice = show_options("Found #{obj.name}!", { pick: "Pick up", cancel: "Leave" }, :single)

        if choice == :pick
          ENTITIES.delete(obj)
          player.move(direction)
        end
      elsif player.would_fit_into_map(map, direction)
        player.move(direction)
      end

    when ACTION_KEYS
      action = ACTION_KEYS[input]

      show_message("Cannot interact with anything here.")

    else
      unless input.nil?
        # show_message("got #{input} / #{input.ord}")
      end
    end
  end

  Curses.close_screen

  puts "Bye!"
rescue => ex
  Curses.close_screen
  raise ex
end
