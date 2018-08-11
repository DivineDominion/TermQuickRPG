#!/usr/bin/env ruby
#encoding: utf-8

require 'curses'
require_relative "player.rb"
require_relative "item.rb"

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
Curses.cbreak # immediate key input
Curses.curs_set(0)  # Invisible cursor
Curses.noecho # Do not print keyboard input

# Spiffy game title
TITLE = "TerminalQuickRPG by DivineDominion / 2018"
Curses.setpos(Curses.lines - 1, (Curses.cols - TITLE.length) / 2)
Curses.addstr(TITLE)
Curses.refresh

def show_message(win, *lines)
  continue_msg = "[Continue]"
  height = lines.length + 4
  longest_line_length = lines.sort { |a,b| a.length <=> b.length }[-1].length
  width = [continue_msg.length, longest_line_length].max + 6
  top, left = (Curses.lines - height) / 2, (Curses.cols - width) / 2
  dialog = win.subwin(height, width, top, left)
  dialog.keypad(true)
  dialog.box("|", "-", "+")

  # Message
  y =  1
  lines.each do |line|
    dialog.setpos(y, 3)
    dialog.addstr(line)
    y += 1
  end

  # Draw divider
  dialog.setpos(y, 0)
  dialog << "+"
  (width - 2).times { dialog << "-" }
  dialog << "+"

  # Continue Button
  y += 1
  dialog.setpos(y, (width - continue_msg.length) / 2)
  dialog.attron(Curses::A_REVERSE)
  dialog.addstr(continue_msg)
  dialog.attroff(Curses::A_REVERSE)

  dialog.refresh
  loop { break if ACTION_KEYS.keys.include?(dialog.getch) }
  dialog.close
end

def show_options(win, options, *lines)
  raise "Options hash missing" if options.count == 0

  height = lines.length + 3 + options.count
  longest_option_length = options.values.sort { |a,b| a.length <=> b.length }[-1].length + 2 # 2 surrounding brackets
  longest_line_length = lines.sort { |a,b| a.length <=> b.length }[-1].length
  width = [longest_option_length, longest_line_length].max + 6
  top, left = (Curses.lines - height) / 2, (Curses.cols - width) / 2
  dialog = win.subwin(height, width, top, left)
  dialog.keypad(true)
  dialog.box("|", "-", "+")

  # Message
  y =  1
  lines.each do |line|
    dialog.setpos(y, 3)
    dialog.addstr(line)
    y += 1
  end

  # Draw divider
  dialog.setpos(y, 0)
  dialog << "+"
  (width - 2).times { dialog << "-" }
  dialog << "+"
  y += 1

  # Option Buttons
  options_start_y = y

  draw_options = lambda do |y, selected_line|
    options.values.each_with_index do |line, i|
      if selected_line == i
        dialog.attron(Curses::A_REVERSE)
      end

      dialog.setpos(y, 3)
      dialog.addstr("[#{line}]")
      y += 1

      if selected_line == i
        dialog.attroff(Curses::A_REVERSE)
      end
    end
  end

  selection = 0
  loop do
    draw_options.call(options_start_y, selection)
    dialog.refresh

    input = win.get_char

    case input
    when -> (c) { DIRECTION_KEYS.keys.include?(c) }
      case DIRECTION_KEYS[input]
      when :up then selection -= 1
      when :down then selection += 1
      end

      if selection < 0
        selection = options.count - 1
      elsif selection >= options.count
        selection = 0
      end

    when -> (c) { ACTION_KEYS.keys.include?(c) }
      if ACTION_KEYS[input] == :use
        dialog.close
        return options.keys[selection]
      end
    end
  end
end

player = Player.new(5,5)

ENTITIES = "The Adventure Begins ...".split("").map.with_index { |c, i| Item.new(2 + i, 2, c, c) }
ENTITIES.delete_if { |e| e.name == " " }
ENTITIES << Item.new(8, 6, "♥", "Heart")
ENTITIES << Item.new(4, 4, "¶", "Mace")
ENTITIES << player

def draw_entities(win)
  ENTITIES.each { |e| e.draw(win) }
end

begin
  win = Curses::Window.new(Curses.lines - 3, Curses.cols - 2, 1, 1)
  win.box(?|, ?-)
  win.keypad(true)

  draw_entities(win)

  quit = false

  while !quit
    win.refresh

    input = win.get_char

    case input
    when "q", Curses::Key::EXIT, Curses::Key::CANCEL, Curses::Key::BREAK
      quit = true

    when -> (c) { DIRECTION_KEYS.keys.include?(c) }
      direction = DIRECTION_KEYS[input]
      old_y, old_x = [player.y, player.x]

      if obj = player.would_collide_with(ENTITIES, direction)
        choice = show_options(win, {:pick => "Pick up", :cancel => "Leave"}, "Found #{obj.name}!")

        if choice == :pick
          ENTITIES.delete(obj)
          player.move(direction)
        end

        win.clear
        win.box(?|, ?-)
        draw_entities(win)
        win.refresh
      else
        player.move(direction)
      end

      win.setpos(old_y, old_x)
      win.addstr(" ")
      player.draw(win)

    when -> (c) { ACTION_KEYS.keys.include?(c) }
      action = ACTION_KEYS[input]

      show_message(win, "Cannot interact with anything here.")
      win.clear
      win.box(?|, ?-)
      draw_entities(win)
      win.refresh
    end
  end

  Curses.close_screen

  puts "Bye!"
rescue => ex
  Curses.close_screen
  raise ex
end
