require "termquickrpg/ui/view"

module TermQuickRPG
  module Interaction
    class TargetView
      include UI::View

      CROSSHAIR = "⨉"

      attr_accessor :map_cutout, :target_offset

      def initialize(map_cutout, target_offset = [0, 0])
        @map_cutout = map_cutout
        @target_offset = target_offset
      end

      def render(border_window: nil, canvas: nil, **opts)
        map_cutout.draw(canvas)
        canvas.setpos(*target_offset.reverse)
        canvas.attron(Curses::A_BLINK | Curses::A_BOLD)#Curses::A_REVERSE)
        canvas.addstr(CROSSHAIR)
        canvas.attroff(Curses::A_BLINK | Curses::A_BOLD)#Curses::A_REVERSE)
      end
    end
  end
end
