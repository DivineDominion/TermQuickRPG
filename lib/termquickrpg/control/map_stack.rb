require "singleton"
require "termquickrpg/observable"

module TermQuickRPG
  module Control
    class MapStack
      include Singleton
      include Observable

      attr_reader :maps
      attr_reader :cache

      def initialize(*maps)
        @maps = maps || []
        @cache = maps.map { |map| [map.id, map] }.to_h
      end

      def push(map)
        return if front && front.id == map.id
        front.active = false if front
        map.active = true
        maps << (cache[map.id] || map)
        cache[map.id] = map unless cache.has_key?(map.id)
      ensure
        notify_listeners(:map_stack_did_change)
      end

      def pop
        map = maps.pop
        front.active = true if front
        map
      ensure
        notify_listeners(:map_stack_did_change)
      end

      def front
        maps.last
      end
    end
  end
end
