require "singleton"
require "termquickrpg/ui/bordered_window"

module TermQuickRPG
  module Control
    class WindowRegistry
      include Singleton

      def create_bordered_window(attrs)
        window = UI::BorderedWindow.new(attrs)
      ensure
        register(window)
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
        windows.each do |window|
          window.refresh(force: false)
        end
      end
    end
  end
end
