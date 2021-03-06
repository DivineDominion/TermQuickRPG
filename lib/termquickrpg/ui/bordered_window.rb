require "curses"
require "forwardable"
require "termquickrpg/ui/window"
require "termquickrpg/ext/curses/curses-resize"
require "termquickrpg/ext/curses/window-draw_box"
require "termquickrpg/ui/responsive_frame"
require "termquickrpg/ui/color"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class BorderedWindow
      include Observable
      include UI::Window
      extend Forwardable

      BORDER_WIDTH = 1

      def_delegators :border_window, :style_name, :style_name=
      attr_reader :frame, :border_window, :content
      attr_accessor :border_color

      def initialize(**attrs)
        attrs = {
          border: :double,
          color: UI::Color::Pair::DEFAULT,
          border_color: UI::Color::Pair::DEFAULT,
          window_attrs: nil
        }.merge(attrs)

        @frame = ResponsiveFrame.new(attrs)

        width, height = @frame.size
        x, y = @frame.origin

        @border_window = Curses::Window.new(height, width, y, x)
        @border_window.style_name = attrs[:border]
        if window_attrs = attrs[:window_attrs]
          @border_window.attrset(window_attrs)
        end

        @border_color = attrs[:border_color]
        attrs[:color].style(@border_window)

        @content = @border_window.subwin(height - 2 * BORDER_WIDTH, width - 2 * BORDER_WIDTH,
                                         y + BORDER_WIDTH, x + BORDER_WIDTH)
        @frame.add_listener(self)
      end

      def origin
        @frame.origin
      end

      def size
        @frame.size
      end

      def content_size
        @content.size
      end

      def refresh(force: false)
        if force
          @border_window.touch
          @border_window.refresh
        else
          @border_window.touch
          @border_window.noutrefresh
        end
      end

      def close
        return if @border_window.nil?
        @border_window.clear
        @border_window.noutrefresh # Register region as needing redraw
        @border_window.close
        @border_window = nil
        notify_listeners(:window_did_close)
      end

      def subviews
        @subviews ||= []
      end

      def add_subview(subview)
        subviews << subview
        self.add_listener(subview)
        subview.superview = self
        notify_listener(subview, :window_frame_did_change, origin, size)
      end

      def frame_did_change(frame, x, y, width, height)
        return if @border_window.nil?
        @border_window.move(y, x)
        @border_window.resize(height, width)
        @content.resize(height - 2 * BORDER_WIDTH, width - 2 * BORDER_WIDTH)

        # Forward event
        notify_listeners(:window_frame_did_change, [x, y], [width, height])
      end

      def render
        super
        return if !@border_window

        @border_window.clear
        @border_window.touch # Touch before refreshing subwindows

        draw_border_box
        draw_subviews

        @border_window.refresh
      end

      private

      def draw_border_box
        border_color.set(@border_window) do
          @border_window.draw_box
        end
      end

      def draw_subviews
        subviews.each do |subview|
          subview.render(frame: @frame, border_window: @border_window, canvas: @content)
        end
      end
    end
  end
end