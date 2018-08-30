require "curses"

module TermQuickRPG
  module UI
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
  end
end
