require "curses"
require "termquickrpg/ext/curses/curses-resize"
require "termquickrpg/ui/responsive_frame"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class BorderedWindow
      include Observable

      BORDER_WIDTH = 1

      attr_reader :frame, :border_window, :content

      def initialize(**attrs)
        @frame = ResponsiveFrame.new(attrs)

        width, height = @frame.size
        x, y = @frame.origin
        @border_window = Curses::Window.new(height, width, y, x)
        @content = @border_window.subwin(height - 2 * BORDER_WIDTH, width - 2 * BORDER_WIDTH,
                                         y + BORDER_WIDTH, x + BORDER_WIDTH)

        @frame.add_listener(self)
      end

      def content_size
        @content.size
      end

      def close
        unless @border_window.nil?
          @border_window.erase
          @border_window.close
        end
      end

      def draw
        return if Curses.closed?

        @border_window.clear
        @border_window.touch # Touch before refreshing subwindows
        @border_window.draw_box(:double)

        yield

        @border_window.refresh
      end

      def frame_did_change(frame, x, y, width, height)
        @border_window.move(y, x)
        @border_window.resize(height, width)
        @content.resize(height - 2 * BORDER_WIDTH, width - 2 * BORDER_WIDTH)

        # Forward event
        notify_listeners(:frame_did_change, x, y, width, height)
      end
    end
  end
end