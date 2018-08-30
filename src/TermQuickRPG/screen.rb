require "curses"
require_relative "observable.rb"

module TermQuickRPG
  class Screen
    include Observable
    SCREEN_SIZE_DID_CHANGE_EVENT = :screen_size_did_change

    attr_reader :size
    def width;  size[:width];  end
    def height; size[:height]; end

    def initialize
      Signal.trap('SIGWINCH') { update_screen_size }
      update_screen_size
    end

    def update_screen_size
      Curses.close_screen
      Curses.init_screen
      @size = Screen.current_screen_size
      notify_listeners(SCREEN_SIZE_DID_CHANGE_EVENT, width, height)
    end

    def self.current_screen_size
      { width: Curses.cols, height: Curses.lines }
    end
  end
end
