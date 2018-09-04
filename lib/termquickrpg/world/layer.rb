module TermQuickRPG
  module World
    class Layer
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def ==(other)
        self.data == other.data
      end

      def replace_tile(location, char)
        x, y = location
        data[y][x] = char
      end

      def cutout(start_x, start_y, width, height)
        line_range = (height == 0) ? (start_y .. -1)
                                   : (start_y ... start_y + height)
        char_range = (width == 0) ? (start_x .. -1)
                                  : (start_x ... start_x + width)
        Layer.new(data[line_range].map { |line| line[char_range] })
      end

      def draw(canvas)
        data.each.with_index do |line, y|
          line.chars.each.with_index do |char, x|
            next if char == " "
            canvas.draw(char, x, y)
          end
        end
      end

      def blocked_tiles(solids)
        return if solids.nil?
        data.map { |line| line.chars.map { |c| solids.include?(c) } }
      end
    end
  end
end
