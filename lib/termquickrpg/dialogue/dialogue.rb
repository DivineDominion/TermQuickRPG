module TermQuickRPG
  module Dialogue
    class Dialogue
      attr_reader :name, :lines
      attr_reader :current_line_no

      def initialize(who, *lines)
        name = who.respond_to?(:name) ? who.name : who
        @name, @lines = name, lines
        @current_line_no = -1
      end

      def advanced_lines
        lines[0..current_line_no]
      end

      def current_line
        lines[current_line_no]
      end

      def advance
        if has_next?
          @current_line_no += 1
        end
      end

      def line_count
        lines.count
      end

      def has_next?
        current_line_no < line_count - 1
      end
    end
  end
end
