require "termquickrpg/ui/view"

module TermQuickRPG
  module Dialogue
    class DialogueView
      include UI::View

      attr_reader :padding

      def initialize(padding: [0,0], name: nil, visible_lines: [], status: :continue)
        @padding = padding
        @name = name
        @visible_lines = visible_lines
        @status = status
      end

      attr_reader :name, :status, :visible_lines

      def name=(value)
        @name = value
      ensure
        needs_display!
      end

      def status=(value)
        @status = value
      ensure
        needs_display!
      end

      def visible_lines=(value)
        @visible_lines = value
      ensure
        needs_display!
      end

      def render(border_window: nil, canvas: nil, **opts)
        raise unless border_window && canvas
        draw_name(border_window)
        draw_lines(canvas)
        draw_status(border_window)
      end

      private

      def draw_name(border_window)
        return unless name
        border_window.setpos(0, 4)
        border_window.addstr(" #{name} ")
      end

      def draw_lines(canvas)
        if visible_lines.count > 3
          lines = visible_lines[-3..-1]
          canvas.setpos(0, padding[:horizontal])
          canvas.addstr("...")
        else
          lines = visible_lines
        end

        lines.each.with_index do |line, i|
          canvas.setpos(i + padding[:vertical], padding[:horizontal])
          canvas.addstr(line)
        end
      end

      def draw_status(border_window)
        # draw "[ MOD ]"
        width, height = border_window.size
        border_window.setpos(height - 1, width - 9)
        border_window.addstr("[")
        if status == :continue
          border_window.addstr(" ")
          border_window.attron(Curses::A_BLINK)
          border_window.addstr("···")
          border_window.attroff(Curses::A_BLINK)
          border_window.addstr(" ")
        else
          border_window.attron(Curses::A_REVERSE)
          border_window.addstr(" ")
          border_window.attron(Curses::A_BLINK)
          border_window.addstr("END")
          border_window.attroff(Curses::A_BLINK)
          border_window.addstr(" ")
          border_window.attroff(Curses::A_REVERSE)
        end
        border_window.addstr("]")
      end
    end
  end
end
