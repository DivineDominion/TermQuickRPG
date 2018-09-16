require "delegate"
require "forwardable"
require "curses"
require "termquickrpg/control/window_registry"
require "termquickrpg/interaction/target_view"

module TermQuickRPG
  module Interaction
    class TargetWindow < SimpleDelegator
      extend Forwardable

      BORDER_WIDTH = 1

      attr_reader :window, :map_cutout, :target_view
      def_delegators :target_view, :target_offset, :target_offset=

      def initialize(map_cutout, origin, size, mode = :use)
        x, y = origin
        width, height = size
        super(Control::WindowRegistry.create_bordered_window(
          x: x, y: y,
          width: width + BORDER_WIDTH * 2, height: height + BORDER_WIDTH * 2,
          border: :singleround,
          window_attrs: Curses::A_BOLD))
        @target_view = TargetView.new(map_cutout)
        add_subview(target_view)
        self.mode = mode
      end

      def mode
        @mode
      end

      def mode=(value)
        @mode = value
        self.target_view.mode = value
        self.border_color = target_view.color
        self.needs_render!
      end
    end
  end
end
