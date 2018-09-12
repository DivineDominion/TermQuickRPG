require "termquickrpg/script/character_commands"
require "termquickrpg/script/dialog_commands"
require "termquickrpg/script/effect_commands"
require "termquickrpg/script/inventory_commands"
require "termquickrpg/script/map_commands"

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

      # Calls the block with appropriate parameters. Invokes script command lambdas.
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

      # -- Script commands --

      attr_accessor :game_dir

      def quit
        exit 0
      end

      include CharacterCommands
      include DialogCommands
      include EffectCommands
      include InventoryCommands
      include MapCommands
    end
  end
end
