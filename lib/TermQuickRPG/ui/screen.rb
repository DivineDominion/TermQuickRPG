require "terminal-size"
require "termquickrpg/util/observable"
require "termquickrpg/util/run_loop"

module TermQuickRPG
  class Screen
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
      RunLoop.main.enqueue { notify_listeners(SCREEN_SIZE_DID_CHANGE_EVENT, width, height) }
    end
  end
end
