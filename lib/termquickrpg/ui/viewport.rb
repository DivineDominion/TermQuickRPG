require "forwardable"
require "termquickrpg/ui/bordered_window"
require "termquickrpg/observable"

module TermQuickRPG
  module UI
    class Viewport
      include Observable

      attr_reader :scroll_x, :scroll_y

      extend Forwardable
      attr_reader :window
      def_delegator :@window, :content, :canvas
      def_delegator :@window, :content_size, :canvas_size

      def initialize(**attrs)
        @window = BorderedWindow.new(attrs)
        @window.add_listener(self)
        @scroll_x, @scroll_y = 0, 0
      end

      def close
        @window.close(refresh: true)
      end

      # Drawing

      def render
        @window.draw do
          yield *map_bounds
        end
      end

      def draw(char, x, y, color = nil)
        color ||= UI::Color::Pair::DEFAULT
        canvas.setpos(y, x)
        color.set(canvas) do
          canvas.addstr("#{char}")
        end
      end

      def undraw(x, y)
        draw(" ", x, y)
      end

      # Scrolling & resizing

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

        x_diff = if x < @scroll_x
                   x - @scroll_x
                 elsif x >= @scroll_x + canvas_width
                   x - (@scroll_x + canvas_width - 1)
                 else
                   0
                 end

        y_diff = if y < @scroll_y
                   y - @scroll_y
                 elsif y >= @scroll_y + canvas_height
                   y - (@scroll_y + canvas_height - 1)
                 else
                   0
                 end
        @scroll_x = @scroll_x + x_diff
        @scroll_y = @scroll_y + y_diff
      ensure
        notify_listeners(:viewport_did_scroll) if (x_diff != 0 || y_diff != 0)
      end
    end
  end
end
