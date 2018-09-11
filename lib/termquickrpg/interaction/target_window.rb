require "termquickrpg/ui/bordered_window"
require "termquickrpg/interaction/map_cutout"

module TermQuickRPG
  module Interaction
    class TargetWindow
      CROSSHAIR = "⨉"
      BORDER_WIDTH = 1

      attr_reader :window, :map_cutout
      attr_accessor :target_offset

      def initialize(map_cutout, origin, size)
        @map_cutout = map_cutout
        x, y = origin
        width, height = size
        attrs = {
          x: x, y: y,
          width: width + BORDER_WIDTH * 2, height: height + BORDER_WIDTH * 2,
          border: :singleround
        }
        @window = UI::BorderedWindow.new(attrs)
        @target_offset = [0,0]
      end

      def close
        window.close(refresh: true)
      end

      def draw
        # window.border_window.attron(Curses::A_BLINK)
        window.border_window.attron(Curses::A_BOLD)
        window.draw do |frame, border, content|
          map_cutout.draw(content)
          content.setpos(*target_offset.reverse)
          content.attron(Curses::A_BLINK | Curses::A_BOLD)#Curses::A_REVERSE)
          content.addstr(CROSSHAIR)
          content.attroff(Curses::A_BLINK | Curses::A_BOLD)#Curses::A_REVERSE)
        end
        window.border_window.attroff(Curses::A_BOLD)
        # window.border_window.attroff(Curses::A_BLINK)
      end
    end
  end
end
