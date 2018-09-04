require "termquickrpg/script/map_commands"
require "termquickrpg/script/character_commands"
require "termquickrpg/script/effect_commands"
require "termquickrpg/ui/dialogs"

module TermQuickRPG
  module Script
    class Context
      class << self
        def main
          @@main ||= new
        end

        def run(&block); main.run(&block); end
      end

      private_class_method :new

      attr_accessor :game_dir

      def run(&block)
        instance_eval(&block)
      end

      def msg(text)
        Curses.refresh
        UI::show_message(text)
        UI::cleanup_after_dialog
      end

      include MapCommands
      include EffectCommands
      include CharacterCommands
    end
  end
end
