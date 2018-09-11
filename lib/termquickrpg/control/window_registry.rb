require "singleton"
require "forwardable"
require "termquickrpg/ui/bordered_window"
require "termquickrpg/ui/effects/full_screen_effect"

module TermQuickRPG
  module Control
    class WindowRegistry
      include Singleton

      class << self
        extend Forwardable
        def_delegators :instance, :create_bordered_window, :create_full_screen_effect
      end

      def create_bordered_window(attrs)
        window = UI::BorderedWindow.new(attrs)
      ensure
        register(window)
      end

      def create_full_screen_effect
        @effect = UI::FullScreenEffect.new
      ensure
        register(@effect)
      end

      def windows
        @windows ||= []
      end

      def register(window)
        window.add_listener(self)
        windows << window
      end

      def bordered_window_did_close(window)
        windows.delete(window)
        redraw_window_stack
      end

      def full_screen_effect_did_close(effect)
        windows.delete(effect)
        @effect = nil if @effect == effect
      end

      def redraw_window_stack
        # Always draw current effect on top
        windows.each do |window|
          next if window == @effect
          window.refresh(force: false)
        end
        if @effect
          @effect.refresh(force: false)
        end
      end
    end
  end
end
