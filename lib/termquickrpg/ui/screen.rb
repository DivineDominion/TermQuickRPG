require "singleton"
require "tty-screen"
require "termquickrpg/observable"
require "termquickrpg/control/run_loop"

module TermQuickRPG
  module UI
    class Screen
      include Singleton

      class << self
        def main; instance; end
        def width;  instance.width;  end
        def height; instance.height; end
      end

      def initialize
        super
        @post_initial_size = true

        # Setting our own handler disables ncurses's `Curses::Key::RESIZE`
        Signal.trap('SIGWINCH') { update_screen_size } # FIXME: causes race conditions; enqueue updates on run loop
        update_screen_size
      end

      include Observable
      SCREEN_SIZE_DID_CHANGE_EVENT = :screen_size_did_change

      attr_accessor :post_initial_size
      attr_reader :size
      def width;  size[1];  end
      def height; size[0]; end

      def add_listener(listener)
        super(listener)

        if post_initial_size && listener.respond_to?(SCREEN_SIZE_DID_CHANGE_EVENT)
          listener.public_send(SCREEN_SIZE_DID_CHANGE_EVENT, self, width, height)
        end
      end

      def update_screen_size
        @size = TTY::Screen.size
        Control::RunLoop.main.enqueue { notify_listeners(SCREEN_SIZE_DID_CHANGE_EVENT, width, height) }
      end
    end
  end
end
