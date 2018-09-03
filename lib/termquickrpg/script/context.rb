require "termquickrpg/script/map_commands"

module TermQuickRPG
  module Script
    class Context
      class << self
        def main
          @@main ||= Context.new()
        end

        def run(&block); main.run(&block); end
      end

      def run(&block)
        instance_eval(&block)
      end

      include MapCommands
    end
  end
end
