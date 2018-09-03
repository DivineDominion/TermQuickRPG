require "termquickrpg/world/positionable"
require "termquickrpg/script/context"

module TermQuickRPG
  module World
    class Trigger
      include Positionable

      attr_reader :script

      def initialize(*location, script)
        @x, @y = location
        @script = script
      end

      def execute
        script.call(Script::Context.new)
      end
    end
  end
end
