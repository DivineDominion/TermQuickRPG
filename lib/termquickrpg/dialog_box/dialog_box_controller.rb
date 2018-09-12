require "curses"
require "termquickrpg/control/default_keys"
require "termquickrpg/audio/sounds"

module TermQuickRPG
  module DialogBox
    class DialogBoxController
      attr_reader :window, :options

      def initialize(options, window)
        @options = options
        @window = window
      end

      def pick_option
        did_pick = nil
        selection = 0
        while did_pick == nil do
          window.selected_option = selection
          window.render

          input = Curses.get_char

          case input
          when Control::DIRECTION_KEYS
            case Control::DIRECTION_KEYS[input]
            when :up then   selection -= 1
            when :down then selection += 1
            else Audio::Sound::beep
            end

            if selection < 0
              selection = options.count - 1
            elsif selection >= options.count
              selection = 0
            end

          when Control::ACTION_KEYS
            if Control::ACTION_KEYS[input] == :use
              did_pick = options.keys[selection]
            else
              Audio::Sound::beep
            end

          when Control::CANCEL_KEYS
            if cancel_key = options.keys.find { |k| k == :cancel || k == :close }
              did_pick = cancel_key
            else
              Audio::Sound::beep
            end

          else
            Audio::Sound::beep
          end
        end

        window.close

        return did_pick
      end
    end
  end
end