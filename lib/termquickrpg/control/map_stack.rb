require "singleton"
require "termquickrpg/observable"

module TermQuickRPG
  module Control
    class MapStack
      include Singleton
      include Observable

      attr_reader :maps

      def initialize(*maps)
        @maps = maps || []
      end

      def push(map)
        if last_map = @maps.last
          last_map.active = false
        end
        @maps << map
      ensure
        notify_listeners(:map_stack_did_change)
      end

      def pop
        map = @maps.pop
        @maps.last.active = true
        map
      ensure
        notify_listeners(:map_stack_did_change)
      end

      def front
        @maps.last
      end
    end
  end
end
