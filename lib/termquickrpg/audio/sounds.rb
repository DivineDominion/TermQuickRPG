require "curses"

module TermQuickRPG
  module Audio
    module Sound
      def self.beep
        Curses.beep
      end
    end
  end
end
