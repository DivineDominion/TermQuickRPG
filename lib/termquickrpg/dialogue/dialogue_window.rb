require "curses"
require "termquickrpg/ui/responsive_frame"
require "termquickrpg/ext/curses/window-draw_box"

module TermQuickRPG
  module Dialogue
    class DialogueWindow
      DEFAULT_WIDTH = 50
      attr_reader :frame
      attr_accessor :name, :visible_lines
      attr_accessor :status

      def initialize(**attrs)
        @visible_lines = []
        @status = :continue

        attrs[:centered] = :horizontal
        attrs[:width] = DEFAULT_WIDTH
        attrs[:height] = 4
        attrs[:padding] = { horizontal: 2, vertical: 1 }
        attrs[:margin] = { bottom: 3 } # Help lines
        attrs[:y] = 1000 # Anchor to bottom edge

        @frame = UI::ResponsiveFrame.new(attrs)
        @frame.add_listener(self)
      end

      def window
        @window ||= create_window
      end

      def create_window
        x, y = frame.origin
        width, height = frame.size
        win = Curses::Window.new(height, width, y, x)
        return win
      end

      def close
        return unless @window # Do not lazily recreate a window
        window.clear
        window.refresh
        window.close
      end

      def draw
        window.clear
        window.draw_box(:double)
        draw_name
        draw_lines
        draw_status
        window.refresh
      end

      def draw_name
        window.setpos(0, 4)
        window.addstr(" #{name} ")
      end

      def draw_lines
        visible_lines.each.with_index do |line, i|
          # +1 for the border
          x, y = 1 + frame.padding[:horizontal], i + 1 + frame.padding[:vertical]
          window.setpos(y, x)
          window.addstr(line)
        end
      end

      def draw_status
        # draw "[ MOD ]"
        window.setpos(frame.height - 1, frame.width - 9)
        window.addstr("[")
        window.attron(Curses::A_REVERSE)
        window.addstr(" ")
        window.attron(Curses::A_BLINK)
        if status == :continue
          window.addstr("...")
        else
          window.addstr("END")
        end
        window.attroff(Curses::A_BLINK)
        window.addstr(" ")
        window.attroff(Curses::A_REVERSE)
        window.addstr("]")
      end

      def frame_did_change(frame, x, y, width, height)
        window.move(y, x)
        window.resize(height, width)
      end
    end
  end
end
