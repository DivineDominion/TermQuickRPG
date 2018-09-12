require "termquickrpg/script/map_commands"
require "termquickrpg/script/character_commands"
require "termquickrpg/script/effect_commands"
require "termquickrpg/inventory"
require "termquickrpg/ui/view_components"

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

      # Calls the block with appropriate parameters.
      def call_block(block, sender)
        if block.arity == 2
          block.call(self, sender)
        elsif block.arity  == 1
          block.call(self)
        else
          raise "Don't know how to call scripts blocks with arity of #{block.arity}."
        end
      end

      # Used inside scripts as `ctx.run { ... }` to actually execute.
      def run(&block)
        instance_eval(&block)
      end

      def quit
        exit 0
      end

      def msg(*lines)
        UI::show_message(*lines)
      end

      def dialogue(who, *lines)
        UI::show_dialogue(who, *lines)
      end

      def request_use_item(message, &block)
        if item = Control::Player.instance.item_from_inventory(message)
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

        if notify.is_a?(String)
          msg notify
        elsif notify
          msg "Obtained #{item.name}!"
        end
      end

      include MapCommands
      include EffectCommands
      include CharacterCommands
    end
  end
end
