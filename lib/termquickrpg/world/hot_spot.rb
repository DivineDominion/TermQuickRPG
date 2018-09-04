require "termquickrpg/world/locatable"
require "termquickrpg/script/context"

module TermQuickRPG
  module World
    class HotSpot
      include Locatable

      attr_reader :script

      def initialize(*location, script)
        @x, @y = location
        @script = script
      end

      def execute(context)
        script.call(context)
      end
    end
  end
end
