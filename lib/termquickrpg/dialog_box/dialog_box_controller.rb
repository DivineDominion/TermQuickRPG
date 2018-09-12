require "curses"
require "termquickrpg/control/default_keys"
require "termquickrpg/audio/sounds"

module TermQuickRPG
  module DialogBox
    class DialogBoxController
      attr_reader :window, :options
      attr_accessor :selection

      def initialize(options, window)
        @options = options
        @window = window
      end

      def pick_option
        picker = PickOption.new(options.keys)
        window.selected_option = picker.selection

        while picker.pick == nil do
          Control::WindowRegistry.instance.render_window_stack

          picker.handle_input do |selection|
            window.selected_option = selection
          end
        end

        window.close
        return picker.pick
      end

      private

      class PickOption
        attr_reader :keys
        attr_reader :selection, :pick

        def initialize(keys)
          @keys = keys
          @selection, @pick = 0, nil
        end

        def handle_input
          input = Curses.get_char

          case input
          when Control::DIRECTION_KEYS
            case Control::DIRECTION_KEYS[input]
            when :up then   @selection -= 1
            when :down then @selection += 1
            else Audio::Sound::beep
            end

            if selection < 0
              @selection = keys.count - 1
            elsif selection >= keys.count
              @selection = 0
            end

            yield selection

          when Control::ACTION_KEYS
            if Control::ACTION_KEYS[input] == :use
              @pick = keys[selection]
            else
              Audio::Sound::beep
            end

          when Control::CANCEL_KEYS
            if cancel_key = keys.find { |k| k == :cancel || k == :close }
              @pick = cancel_key
            else
              Audio::Sound::beep
            end

          else
            Audio::Sound::beep
          end
        end
      end
    end
  end
end