require "terminal-size"
require "termquickrpg/observable"
require "termquickrpg/util/run_loop"

module TermQuickRPG
  module UI
    class Screen
      class << self
        def main
          @@main ||= Screen.new(post_initial_size: true)
        end

        def width;  main.width;  end
        def height; main.height; end
      end

      private :initialize

      include Observable
      SCREEN_SIZE_DID_CHANGE_EVENT = :screen_size_did_change

      attr_accessor :post_initial_size
      attr_reader :size
      def width;  size[:width];  end
      def height; size[:height]; end

      def initialize(**attrs)
        attrs = { post_initial_size: false }.merge(attrs)
        attrs.each { |k, v| send "#{k}=", v }

        # Setting our own handler disables ncurses's `Curses::Key::RESIZE`
        Signal.trap('SIGWINCH') { update_screen_size } # FIXME: causes race conditions; enqueue updates on run loop
        update_screen_size
      end

      def add_listener(listener)
        super(listener)

        if post_initial_size && listener.respond_to?(SCREEN_SIZE_DID_CHANGE_EVENT)
          listener.public_send(SCREEN_SIZE_DID_CHANGE_EVENT, self, width, height)
        end
      end

      def update_screen_size
        @size = Terminal.size
        Util::RunLoop.main.enqueue { notify_listeners(SCREEN_SIZE_DID_CHANGE_EVENT, width, height) }
      end
    end
  end
end
