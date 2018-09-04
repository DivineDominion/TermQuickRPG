require "forwardable"
require "termquickrpg/ui/bordered_window"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class Viewport
      include Observable
      VIEWPORT_DID_SCROLL = :viewport_did_scroll

      attr_reader :scroll_x, :scroll_y

      def initialize(**attrs)
        @window = BorderedWindow.new(attrs)
        @scroll_x, @scroll_y = 0, 0
      end

      extend Forwardable
      def_delegator :@window, :content, :canvas
      def_delegator :@window, :content_size, :canvas_size
      def_delegator :@window, :close

      def draw
        width, height = canvas_size
        @window.draw do
          yield @scroll_x, @scroll_y, width, height
        end
      end

      def adjust_to_screen_size(width, height)
        @window.adjust_to_screen_size(width, height)
      end

      def track_movement(character)
        character.add_listener(self) # :character_did_move
      end

      def character_did_move(character, x, y)
        scroll_to_visible([x, y])
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
        notify_listeners(VIEWPORT_DID_SCROLL) if did_scroll
      end
    end
  end
end
