require "curses"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class FullScreenEffect
      include Observable

      attr_reader :window

      def initialize
        @window = Curses::Window.new(Curses.lines, Curses.cols, 0, 0)
      end

      def close
        unless @window.nil?
          @window.erase
          @window.noutrefresh
          @window.close
          @window = nil
          notify_listeners(:full_screen_effect_did_close)
        end
      end

      def refresh(force: false)
        if force
          @window.refresh
        else
          @window.noutrefresh
        end
      end

      def render
        yield window
      end
    end
  end
end