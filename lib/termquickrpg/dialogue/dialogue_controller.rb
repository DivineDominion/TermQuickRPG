require "curses"
require "termquickrpg/dialogue/dialogue"
require "termquickrpg/dialogue/dialogue_window"
require "termquickrpg/audio/sounds"

module TermQuickRPG
  module Dialogue
    class DialogueController
      attr_reader :dialogue, :window

      def initialize(dialogue, window = DialogueWindow.new)
        @dialogue = dialogue
        @window = window
      end

      def advance_dialogue
        dialogue.advance
        window.name = dialogue.name
        window.visible_lines = dialogue.advanced_lines
        window.status = :end unless dialogue.has_next?
      end

      def show_dialogue
        advance_dialogue
        has_quit = false
        while !has_quit do
          Control::WindowRegistry.instance.render_window_stack

          has_quit = handle_input
        end
        window.close
      end

      private

      def handle_input
        input = Curses.get_char
        if Control::ACTION_KEYS[input] == :use
          if dialogue.has_next?
            advance_dialogue
          else
            return true
          end
        else
          Audio::Sound::beep
        end
        return false
      end
    end
  end
end
