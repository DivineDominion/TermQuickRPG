require "weakref"
require "termquickrpg/ui/window"

module TermQuickRPG
  module UI
    module View
      def superview=(superview)
        @superview = WeakRef.new(superview)
      ensure
        needs_display!
      end

      def superview
        @superview.weakref_alive? ? @superview.__getobj__ : nil
      end

      def window
        return superview if superview.is_a?(UI::Window)
        superview.window
      end

      def needs_display!
        window.needs_render!
      end
    end
  end
end
