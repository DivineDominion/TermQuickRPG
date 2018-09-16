require "termquickrpg/interaction/target_controller"
require "termquickrpg/interaction/map_cutout"

module TermQuickRPG
  module Interaction
    class Picker
      attr_reader :map
      attr_reader :center, :radius
      attr_reader :origin, :size
      attr_reader :frame_origin

      def initialize(map, center, screen_translator, radius = 1)
        @map = map
        @center, @radius = center, radius

        start_x, start_y = center.map { |i| i - radius}
        end_x, end_y = center.map { |i| i + radius}
        @origin = [start_x, start_y]
        @size = [(start_x..end_x).count, (start_y..end_y).count]
        @frame_origin = screen_translator.translate_map_to_screen([start_x, start_y])
      end

      def controller
        @controller ||= Interaction::TargetController.new(size, [radius, radius], Interaction::TargetWindow.new(Interaction::MapCutout.new(map, origin, size), frame_origin, size))
      end

      def pick_target
        controller.reset_target

        target_offset, did_cancel = nil, false
        while !(target_offset || did_cancel) do
          Control::WindowRegistry.instance.render_window_stack

          input = Curses.get_char

          case input
          when Control::ACTION_KEYS
            if Control::ACTION_KEYS[input] == :use
              target_offset = controller.target_offset
            else
              Audio::Sound::beep
            end

          when Control::CANCEL_KEYS # Cancel or quit will close
            did_cancel = true

          when Control::DIRECTION_KEYS
            offset = controller.move_picker(Control::DIRECTION_KEYS[input])
            x,y = origin[0]-radius+offset[0], origin[1]-radius+offset[1]

          when ?f, ?F, ?m, ?M
            controller.toggle_mode

          else
            Audio::Sound::beep
          end
        end

        controller.close_window

        return nil if !target_offset

        x_off, y_off = target_offset
        x, y = origin
        [x + x_off, y + y_off]
      end
    end
  end
end
