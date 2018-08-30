require "terminal-size"
require_relative "observable.rb"

module TermQuickRPG
  class Screen
    include Observable
    SCREEN_SIZE_DID_CHANGE_EVENT = :screen_size_did_change

    attr_reader :size
    def width;  size[:width];  end
    def height; size[:height]; end

    def initialize
      # Setting our own handler disables ncurses's `Curses::Key::RESIZE`
      Signal.trap('SIGWINCH') { update_screen_size }
      update_screen_size
    end

    def update_screen_size
      @size = Terminal.size
      notify_listeners(SCREEN_SIZE_DID_CHANGE_EVENT, width, height)
    end
  end
end
