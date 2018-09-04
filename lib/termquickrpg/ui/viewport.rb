require "forwardable"
require "termquickrpg/ui/bordered_window"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class Viewport
      include Observable

      attr_reader :scroll_x, :scroll_y

      def initialize(**attrs)
        @window = BorderedWindow.new(attrs)
        @window.add_listener(self)
        @scroll_x, @scroll_y = 0, 0
      end

      extend Forwardable
      def_delegator :@window, :content, :canvas
      def_delegator :@window, :content_size, :canvas_size
      def_delegator :@window, :close

      def draw
        @window.draw do
          yield *map_bounds
        end
      end

      def map_bounds
        width, height = canvas_size
        [@scroll_x, @scroll_y, width, height]
      end

      def frame_did_change(frame, *args)
        width, height = canvas_size
        notify_listeners(:viewport_size_did_change, width, height)
      end

      def track_movement(character)
        character.add_listener(self) # :character_did_move
      end

      def character_did_move(character, from, to)
        scroll_to_visible(to)
      end

      def scroll_to_visible(obj)
        x, y = obj.respond_to?(:location) ? obj.location : obj
        canvas_width, canvas_height = canvas_size
        did_scroll = false

        while x < @scroll_x
          @scroll_x -= 1
          did_scroll = true
        end

        while y < @scroll_y
          @scroll_y -= 1
          did_scroll = true
        end

        while x >= @scroll_x + canvas_width
          @scroll_x += 1
          did_scroll = true
        end

        while y >= @scroll_y + canvas_height
          @scroll_y += 1
          did_scroll = true
        end
      ensure
        notify_listeners(:viewport_did_scroll) if did_scroll
      end
    end
  end
end
