module TermQuickRPG
  module UI
    module Window
      def needs_render
        @needs_render ||= true
      end

      def needs_render=(value)
        @needs_render = value
      end

      def needs_render!
        needs_render = true
      end

      def render
        needs_render = false
      end
    end
  end
end
