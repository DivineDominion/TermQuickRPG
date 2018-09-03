require "termquickrpg/script/map_commands"

module TermQuickRPG
  module Script
    class Context
      def run(&block)
        instance_eval(&block)
      end

      include MapCommands
    end
  end
end
