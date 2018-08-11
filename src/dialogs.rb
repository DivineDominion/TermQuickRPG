require "curses"

module Curses
  class Window
    STYLES = {
      :single => %Q{┌─┐││└─┘├─┤},
      :double => %Q{╔═╗║║╚═╝╟─╢},
      :plusdash => %Q{+-+||+-++-+}
    }

    def draw_box(style)
      style = STYLES[style]
      raise "Style not found" if style.nil?

      width, height = maxx, maxy

      setpos(0, 0)
      addstr(style[0])
      (width - 2).times { addstr(style[1]) }
      addstr(style[2])

      (height - 2).times do |y|
        setpos(y + 1, 0)
        addstr(style[3])
        setpos(y + 1, width - 1)
        addstr(style[4])
      end

      setpos(height - 1, 0)
      addstr(style[5])
      (width - 2).times { addstr(style[6]) }
      addstr(style[7])
    end

    def draw_divider(style, y)
      style = STYLES[style]
      raise "Style not found" if style.nil?

      setpos(y, 0)
      addstr(style[8])
      (maxx - 2).times { addstr(style[9]) }
      addstr(style[10])
    end
  end
end

def show_message(*lines)
  show_options(*lines, "Continue")
end

def show_options(*lines, options)
  raise "Options hash missing" if options.length == 0

  # Wrap string options in hash
  options = options.is_a?(Hash) ? options : { close: options }

  longest_option_length = options.values.sort { |a,b| a.length <=> b.length }[-1].length
  longest_option_length += 2 # surrounding brackets
  longest_line_length = lines.sort { |a,b| a.length <=> b.length }[-1].length
  width = [longest_option_length, longest_line_length].max + 6
  height = lines.length + 3 + options.count

  top, left = (Curses.lines - height) / 2, (Curses.cols - width) / 2
  dialog = Curses::Window.new(height, width, top, left)
  dialog.keypad(true)
  dialog.draw_box(:double)

  # Message
  y =  1
  lines.each do |line|
    dialog.setpos(y, 3)
    dialog.addstr(line)
    y += 1
  end

  # Draw divider
  dialog.draw_divider(:double, y)
  y += 1

  # Option Buttons
  options_start_y = y

  draw_options = ->(y, selected_line) do
    # Center sole options
    x = if options.count == 1
          (width - options.values[0].length) / 2
        else
          3
        end

    options.values.each_with_index do |line, i|
      if selected_line == i
        dialog.attron(Curses::A_REVERSE)
      end

      dialog.setpos(y, x)
      dialog.addstr("[#{line}]")
      y += 1

      if selected_line == i
        dialog.attroff(Curses::A_REVERSE)
      end
    end
  end

  selection = 0
  loop do
    draw_options.call(options_start_y, selection)
    dialog.refresh

    input = Curses.get_char

    case input
    when -> (c) { DIRECTION_KEYS.keys.include?(c) }
      case DIRECTION_KEYS[input]
      when :up then selection -= 1
      when :down then selection += 1
      end

      if selection < 0
        selection = options.count - 1
      elsif selection >= options.count
        selection = 0
      end

    when -> (c) { ACTION_KEYS.keys.include?(c) }
      if ACTION_KEYS[input] == :use
        dialog.close
        return options.keys[selection]
      end
    end
  end
end