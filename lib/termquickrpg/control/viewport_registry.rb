require "singleton"
require "weakref"

module TermQuickRPG
  module Control
    # The "main" viewport is considered to be the active and central
    # viewport of the game where UI is drawn into. Auxiliary viewports do not
    # get the same treatment, e.g. for action pickers.
    class ViewportRegistry
      include Singleton

      def viewports
        @viewports ||= []
      end

      def register(viewport, as_main: false)
        viewport.add_listener(self)
        viewports << viewport
        @main = viewport if as_main
      end

      def viewport_did_close(viewport)
        viewports.delete(viewport)
        @main = nil if @main == viewport
      end

      def main
        @main || viewports.first
      end
    end
  end
end
