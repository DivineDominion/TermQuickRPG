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
        def_delegators :instance, :create_bordered_window, :create_full_screen_effect, :create_help_line_window
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

      def create_help_line_window
        window = UI::HelpLineWindow.new
      ensure
        register(window)
      end

      def windows
        @windows ||= []
      end

      def register(window)
        if window.respond_to?(:add_listener)
          window.add_listener(self)
        end

        windows << window
      end

      def window_did_close(window)
        windows.delete(window)
        refresh_window_stack
        # Re-render all remaining windows
        windows.each do |window|
          window.needs_render!
        end
      end

      def full_screen_effect_did_close(effect)
        windows.delete(effect)
        @effect = nil if @effect == effect
        refresh_window_stack#(force: true)
        render_window_stack # Effect sequences may block the game loop's redrawing
      end

      def refresh_window_stack(force: false)
        # Always draw current effect on top
        windows.each do |window|
          next if window == @effect
          window.refresh(force: force)
        end
        if @effect
          @effect.refresh(force: force)
        end
      end

      def render_window_stack(force: false)
        # Always draw current effect on top
        window_below_needed_render = force
        windows.each do |window|
          next if window == @effect
          window_below_needed_render ||= window.needs_render
          next unless window_below_needed_render
          window.render
        end
        if @effect
          @effect.render
        end
      end
    end
  end
end
