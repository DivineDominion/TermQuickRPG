require "termquickrpg/ui/window"
require "termquickrpg/ui/responsive_frame"

module TermQuickRPG
  module UI
    class HelpLineWindow
      include UI::Window

      TITLE = "TerminalQuickRPG by DivineDominion / 2018"
      HELP = "W,A,S,D to move  [I]nventory Us[e] [Q]uit "

      attr_reader :frame

      def initialize(**attrs)
        width = lines.map(&:length).max

        attrs[:centered] = :horizontal
        attrs[:width] = width
        attrs[:height] = 2
        attrs[:y] = 1000 # Anchor to bottom edge

        @frame = ResponsiveFrame.new(attrs)
        @frame.add_listener(self)
      end

      def lines
        [TITLE, HELP]
      end

      def window
        @window ||= create_window
      end

      def create_window
        x, y = frame.origin
        width, height = frame.size
        win = Curses::Window.new(height, width, y, x)
        win.setpos(0,0)
        win.addstr(lines.join("\n"))
        return win
      end

      def render
        super
        window.touch # Mark as needing re-display
        window.refresh
      end

      def refresh(force: false)
        if force
          window.refresh
        else
          window.noutrefresh
        end
      end

      def frame_did_change(frame, x, y, width, height)
        window.move(y, x)
        window.resize(height, width)
      end
    end
  end
end