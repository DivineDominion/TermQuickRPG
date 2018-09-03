require "termquickrpg/world/locatable"
require "termquickrpg/script/context"

module TermQuickRPG
  module World
    class Trigger
      include Locatable

      attr_reader :script

      def initialize(*location, script)
        @x, @y = location
        @script = script
      end

      def execute
        script.call(Script::Context.main)
      end
    end
  end
end
