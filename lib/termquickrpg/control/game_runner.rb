require "curses"
require "termquickrpg/ext/curses/curses-resize"

require "termquickrpg/ui/help_line_window"
require "termquickrpg/control/run_loop"

require "termquickrpg/map_display/map_view"
require "termquickrpg/map_display/viewport"
require "termquickrpg/control/viewport_registry"
require "termquickrpg/control/map_stack"

require "termquickrpg/control/user_input"
require "termquickrpg/control/player"
require "termquickrpg/script/context"

class Hash
  # case matching
  def ===(element)
    self.has_key?(element)
  end
end

class Array
  def reverse_each_with_index &block
    to_enum.with_index.reverse_each &block
  end
end

require "singleton"

module TermQuickRPG
  module Control
    class GameRunner
      include Singleton

      def user_input
        @user_input ||= Control::UserInput.new
      end

      def quit!
        @keep_running = false
      end

      def game_loop
        @keep_running = true
        while @keep_running
          Control::RunLoop.main.run do
            draw
            handle_input
            GC.start # Clean up weak references of observers
          end
        end
      end

      def draw
        Control::WindowRegistry.instance.render_window_stack
      end

      def handle_input
        user_input.process(player, map)
      end

      # Map display


      attr_reader :player, :map

      def map_views
        @map_views ||= []
      end

      def map_stack_did_change(map_stack)
        leave_map(@map)

        if map = map_stack.front
          @map = map
          @player ||= Control::Player.instance
          @player.switch_control(map.player_character)
          show_map(map)
        else
          @map = nil
          @player = nil
        end
      end

      def show_map(map)
        map_window = Control::WindowRegistry.create_bordered_window(
          width: 30, height: 15, y: 2,
          margin: {bottom: 2}, # bottom screen help lines
          centered: [:horizontal])
        viewport = MapDisplay::Viewport.new(scroll_padding: [8, 4])
        ViewportRegistry.instance.register(viewport, as_main: true)
        map_view = MapDisplay::MapView.new(map, viewport)
        map_views << map_view
        map_window.add_subview(map_view)
        viewport.center_on(map.player_character)
        viewport.track_movement(map.player_character)

        # # Demo dual views
        # viewport2 = MapDisplay::Viewport.new(
        #   width: 9, height: 5, x: 100,
        #   centered: [:vertical],
        #   scroll_padding: [-1, -1])
        # viewport2.center_on(map.player_character)
        # viewport2.track_movement(map.player_character)
        # ViewportRegistry.instance.register(viewport2)
        # map_views << MapDisplay::MapView.new(map, viewport2)
      end

      def leave_map(map)
        # Delete backwards to not shrink the array while enumerating
        map_views.reverse_each_with_index do |map_view, index|
          if map_view.map == map
            map_view.window.close
            map_views.delete_at(index)
          end
        end
      end
    end
  end
end
