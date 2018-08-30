require "curses"

module TermQuickRPG
  module UI
    DIRECTION_KEYS = {
      ?w => :up,
      ?s => :down,
      ?a => :left,
      ?d => :right,

      ?W => :up,
      ?S => :down,
      ?A => :left,
      ?D => :right,

      Curses::Key::UP => :up,
      Curses::Key::DOWN => :down,
      Curses::Key::LEFT => :left,
      Curses::Key::RIGHT => :right
    }

    ACTION_KEYS = {
      ?e => :use,
      ?E => :use,
      " " => :use,
      "\n" => :use,
      "\r" => :use,
      Curses::Key::ENTER => :use
    }
  end
end
