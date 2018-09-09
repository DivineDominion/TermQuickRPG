require "curses"

module TermQuickRPG
  module Control
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

    CANCEL_KEYS = {
      ?q => :quit,
      ?Q => :quit,

      "\e" => :cancel,
      Curses::Key::EXIT => :cancel,
      Curses::Key::CANCEL => :cancel,
      Curses::Key::BREAK => :cancel
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
