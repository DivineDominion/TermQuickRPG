require "curses"
require "termquickrpg/ext/curses/window-draw_box"
require "termquickrpg/control/default_keys" # FIXME: dep in wrong direction
require "termquickrpg/control/run_loop"

module Curses
  class Window
    def with_attrs(*attrs)
      attrs.flatten!
      attrs.each { |a| attron(a) }
      yield
      attrs.each { |a| attroff(a) }
    end
  end
end

require "termquickrpg/dialogue/dialogue"
require "termquickrpg/dialogue/dialogue_controller"

module TermQuickRPG
  module UI
    def self.show_dialogue(name, *lines)
      Dialogue::DialogueController.new(Dialogue::Dialogue.new(name, *lines)).show_dialogue
    end
  end
end

module TermQuickRPG
  module UI
    def self.cleanup_after_dialog(force: false)
      if force
        Curses.clear
        Curses.refresh
      else
        Control::RunLoop.main.enqueue {
          Curses.clear
          Curses.refresh
        }
      end
    end

    def self.show_message(*lines)
      show_options(*lines, "Continue", :single)
    end

    def self.show_options(*lines, options, style)
      raise "Options hash missing" if options.length == 0

      options = if options.is_a?(Hash)
                  options
                elsif options.is_a?(Array)
                  options.map.with_index { |opt, i| [i, opt] }.to_h
                else
                  # Wrap single string option in hash
                  { close: options }
                end

      longest_option_length = options.values.sort { |a,b| a.length <=> b.length }[-1].length
      longest_option_length += 2 # surrounding brackets
      longest_line_length = lines.sort { |a,b| a.length <=> b.length }[-1].length
      width = [longest_option_length, longest_line_length].max + 6
      height = lines.length + 3 + options.count

      top, left = (Curses.lines - height) / 2, (Curses.cols - width) / 2
      dialog = Curses::Window.new(height, width, top, left)
      dialog.keypad(true)
      dialog.draw_box(style)

      # Message
      y =  1
      lines.each do |line|
        dialog.setpos(y, 3)
        dialog.addstr(line)
        y += 1
      end

      # Draw divider
      dialog.draw_divider(style, y)
      y += 1

      # Option Buttons
      options_start_y = y

      draw_options = ->(y, selected_line) do
        x = if options.count == 1
              # Center sole options
              (width - options.values[0].length) / 2
            else
              # Nudge in regular option
              3
            end

        options.values.each_with_index do |line, i|
          dialog.with_attrs(selected_line == i ? Curses::A_STANDOUT : []) do
            dialog.setpos(y, x)
            dialog.addstr("[#{line}]")
            y += 1
          end
        end
      end

      selection = 0
      loop do
        draw_options.call(options_start_y, selection)
        dialog.refresh

        input = Curses.get_char

        case input
        when Control::DIRECTION_KEYS
          case Control::DIRECTION_KEYS[input]
          when :up then selection -= 1
          when :down then selection += 1
          end

          if selection < 0
            selection = options.count - 1
          elsif selection >= options.count
            selection = 0
          end

        when Control::ACTION_KEYS
          if Control::ACTION_KEYS[input] == :use
            dialog.clear
            dialog.refresh
            dialog.close
            return options.keys[selection]
          end
        end
      end
    end
  end
end
