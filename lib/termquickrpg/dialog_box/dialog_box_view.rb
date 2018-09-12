require "termquickrpg/ui/view"
require "termquickrpg/ext/curses/window-draw_box"
require "termquickrpg/ext/curses/window-with_attrs"

module TermQuickRPG
  module DialogBox
    class DialogBoxView
      include UI::View

      X_PADDING = 2

      attr_reader :lines, :options
      attr_accessor :selected_option

      def initialize(lines, options)
        raise "Options hash missing" if !options || options.length == 0

        @lines = lines || []
        @options = if options.is_a?(Hash)
                     options
                   elsif options.is_a?(Array)
                     options.map.with_index { |opt, i| [i, opt] }.to_h
                   else
                     # Wrap single string option in hash
                     { close: options.to_s }
                   end
      end

      def intrinsic_size
        if @intrinsic_size
          @intrinsic_size
        else
          longest_option_length = options.values.sort { |a,b| a.length <=> b.length }[-1].length
          longest_option_length += 2 # surrounding brackets
          longest_line_length = lines.sort { |a,b| a.length <=> b.length }[-1].length
          width = [longest_option_length, longest_line_length].max + 2 * X_PADDING
          height = lines.length + options.count + 1 # 1 divider line
          @intrinsic_size = [width, height]
        end
      end

      def render(border_window: nil, canvas: nil, **opts)
        raise unless border_window && canvas
        draw_message(canvas)
        draw_divider(border_window)
        draw_options(canvas)
      end

      private

      def draw_message(canvas)
        lines.each_with_index do |line, lineno|
          canvas.setpos(lineno, 3)
          canvas.addstr(line)
        end
      end

      def draw_divider(border_window)
        border_window.draw_divider(lines.length + 1)
      end

      def draw_options(canvas)
        width, height = intrinsic_size
        x = if options.count == 1
              # Center sole option
              (width - options.values[0].length) / 2
            else
              # Nudge in regular option
              2
            end

        start_y = lines.length + 1 # divider
        options.values.each_with_index do |line, lineno|
          y = start_y + lineno
          canvas.with_attrs(selected_option == lineno ? Curses::A_STANDOUT : []) do
            canvas.setpos(y, x)
            canvas.addstr("[#{line}]")
          end
        end
      end
    end
  end
end