require "termquickrpg/ui/view"
require "termquickrpg/ui/color"

module TermQuickRPG
  module Interaction
    class TargetView
      include UI::View

      CROSSHAIR = {
        attack: "⨉",
        use: "∷"
      }

      def initialize(map_cutout, target_offset = [0, 0], mode = :use)
        @map_cutout = map_cutout
        @target_offset = target_offset
        @mode = mode
      end

      attr_reader :map_cutout, :target_offset
      attr_accessor :mode

      def map_cutout=(value)
        @map_cutout = value
      ensure
        needs_display!
      end

      def target_offset=(value)
        @target_offset = value
      ensure
        needs_display!
      end

      def color
        return (mode == :attack) \
          ? UI::Color::Pair::BATTLE_UI \
          : UI::Color::Pair::DEFAULT
      end

      def render(border_window: nil, canvas: nil, **opts)
        draw_cutout(canvas)
        draw_target(canvas)
      end

      private

      def draw_cutout(canvas)
        map_cutout.draw(canvas)
      end

      def draw_target(canvas)
        canvas.setpos(*target_offset.reverse)

        attrs = Curses::A_BLINK | Curses::A_BOLD
        canvas.attron(attrs)
        color.set(canvas) do |variable|
          canvas.addstr(CROSSHAIR[mode])
        end
        canvas.attroff(attrs)
      end
    end
  end
end
