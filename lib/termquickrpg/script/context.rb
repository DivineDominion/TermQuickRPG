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

      attr_accessor :game_dir

      def run(&block)
        instance_eval(&block)
      end

      include MapCommands
    end
  end
end
