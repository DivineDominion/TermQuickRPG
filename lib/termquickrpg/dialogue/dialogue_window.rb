require "curses"
require "termquickrpg/ui/bordered_window"

module TermQuickRPG
  module Dialogue
    class DialogueWindow
      NUM_COLS = 50
      NUM_LINES = 3

      attr_reader :window, :padding
      attr_accessor :name, :visible_lines
      attr_accessor :status

      def initialize(**attrs)
        @visible_lines = []
        @status = :continue
        @padding = { horizontal: 2, vertical: 1 }

        # Override customizations
        attrs[:centered] = :horizontal
        attrs[:width] = NUM_COLS + 2 * @padding[:horizontal] + 2 # Borders inclusive
        attrs[:height] = NUM_LINES + 2 * @padding[:vertical] + 2
        attrs[:margin] = { bottom: 3 } # Help lines
        attrs[:y] = 1000 # Anchor to bottom edge
        attrs[:border] = :double

        @window = UI::BorderedWindow.new(attrs)
        @window.add_listener(self)
      end

      def close
        unless window.nil?
          window.close(refresh: true)
        end
      end

      def draw
        window.draw do |frame, border, content|
          draw_name(border)
          draw_lines(content)
          draw_status(border)
        end
      end

      private

      def draw_name(border)
        border.setpos(0, 4)
        border.addstr(" #{name} ")
      end

      def draw_lines(content)
        if visible_lines.count > 3
          lines = visible_lines[-3..-1]
          content.setpos(0, padding[:horizontal])
          content.addstr("...")
        else
          lines = visible_lines
        end

        lines.each.with_index do |line, i|
          content.setpos(i + padding[:vertical], padding[:horizontal])
          content.addstr(line)
        end
      end

      def draw_status(border)
        # draw "[ MOD ]"
        border.setpos(border.height - 1, border.width - 9)
        border.addstr("[")
        if status == :continue
          border.addstr(" ")
          border.attron(Curses::A_BLINK)
          border.addstr("···")
          border.attroff(Curses::A_BLINK)
          border.addstr(" ")
        else
          border.attron(Curses::A_REVERSE)
          border.addstr(" ")
          border.attron(Curses::A_BLINK)
          border.addstr("END")
          border.attroff(Curses::A_BLINK)
          border.addstr(" ")
          border.attroff(Curses::A_REVERSE)
        end
        border.addstr("]")
      end
    end
  end
end
