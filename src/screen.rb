require "curses"

module TermQuickRPG
  class Screen
    SCREEN_SIZE_DID_CHANGE_EVENT = :screen_size_did_change
    attr_reader :size

    def initialize
      Signal.trap('SIGWINCH') { update_screen_size }
      update_screen_size
    end

    def update_screen_size
      @size = Screen.current_screen_size
    end

    def self.current_screen_size
      { width: Curses.cols, height: Curses.lines }
    end
  end
end
