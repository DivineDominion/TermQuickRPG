require "thread"

module TermQuickRPG
  module Control
    # Main game loop handler. Use RunLoop#enqueue to ensure that a block is
    # executed after the current RunLoop#run finishes.
    class RunLoop
      class << self
        def main
          @@main ||= RunLoop.new
        end
      end

      private :initialize

      def initialize
        @next_tasks_queue = Queue.new
      end

      def run
        process_task_queue
        yield
      end

      def enqueue(&block)
        @next_tasks_queue << block
      end

      private

      def process_task_queue
        # Replace @next_tasks_queue so additional enqueued tasks will be processed in the next run
        current_task_queue = @next_tasks_queue
        @next_tasks_queue = Queue.new

        until current_task_queue.empty?
          task = current_task_queue.pop(true) rescue nil
          if task
            task.call()
          end
        end
      end
    end
  end
end
