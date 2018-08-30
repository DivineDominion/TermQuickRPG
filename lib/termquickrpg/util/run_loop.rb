module TermQuickRPG
  module Util
    # Main game loop handler. Use RunLoop#enqueue to ensure that a block is
    # executed after the current RunLoop#run finishes.
    class RunLoop
      class << self
        def main
          @@main ||= RunLoop.new
        end
      end

      private :initialize

      def run
        @enqueued_blocks.reverse.each { |b| b.call() }
        @enqueued_blocks = []

        yield
      end

      def enqueue(&block)
        @enqueued_blocks ||= []
        @enqueued_blocks << block
      end
    end
  end
end
