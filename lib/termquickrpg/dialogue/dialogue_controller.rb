require "curses"
require "termquickrpg/dialogue/dialogue"
require "termquickrpg/dialogue/dialogue_window"
require "termquickrpg/ui/dialogs" # for cleanup

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
          window.draw
          input = Curses.get_char
          if Control::ACTION_KEYS[input] == :use
            if dialogue.has_next?
              advance_dialogue
            else
              has_quit = true
            end
          end
        end
        window.close
      end
    end
  end
end
