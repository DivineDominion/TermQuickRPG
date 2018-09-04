require "termquickrpg/script/map_commands"
require "termquickrpg/script/character_commands"
require "termquickrpg/script/effect_commands"
require "termquickrpg/control/inventory"
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

      def quit
        exit 0
      end

      # Quickfix to redraw the map after cleanin up UI artifacts; should become obsolete with usage of Panels
      def redraw_current_map
        Control::MapStack.instance.front.invalidate!
      end

      def msg(*lines)
        UI::show_message(*lines)
      end

      def request_use_item(message, &block)
        if item = Control::Player.instance.item_from_inventory(message)
          UI::cleanup_after_dialog(force: true)
          redraw_current_map

          yield item
          return true
        else
          return false
        end
      end

      def take(item)
        Control::Player.instance.remove_from_inventory(item)
      end

      def give(item, notify = true)
        Control::Player.instance.take(item)

        if notify
          msg "Obtained #{item.name}!"
          UI::cleanup_after_dialog(force: true)
        end
      end

      include MapCommands
      include EffectCommands
      include CharacterCommands
    end
  end
end
