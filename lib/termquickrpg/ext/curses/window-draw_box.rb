require "curses"

module Curses
  class Window
    STYLES = {
      :single => %Q{┌─┐││└─┘├─┤},
      :singleround => %Q{╭─╮││╰─╯├─┤},
      :double => %Q{╔═╗║║╚═╝╟─╢},
      :plusdash => %Q{+-+||+-++-+},
      :halfout => %Q{▛▀▜▌▐▙▄▟▚▄▞},
      :halfin => %Q{▗▄▖▐▌▝▀▘▚▄▞},
      :halfcorners => %Q{▛ ▜  ▙ ▟   }
    }

    attr_accessor :border

    def draw_box(style_name = nil)
      @border ||= STYLES[style_name]
      raise "Style not found: '#{style_name}'" if @border.nil?

      width, height = maxx, maxy

      setpos(0, 0)
      addstr(border[0])
      (width - 2).times { addstr(border[1]) }
      addstr(border[2])

      (height - 2).times do |y|
        setpos(y + 1, 0)
        addstr(border[3])
        setpos(y + 1, width - 1)
        addstr(border[4])
      end

      setpos(height - 1, 0)
      addstr(border[5])
      (width - 2).times { addstr(border[6]) }
      addstr(border[7])
    end

    def draw_divider(y, style_name = nil)
      @border ||= STYLES[style_name]
      raise "Style not found: '#{style_name}'" if @border.nil?

      setpos(y, 0)
      addstr(border[8])
      (maxx - 2).times { addstr(border[9]) }
      addstr(border[10])
    end
  end
end
