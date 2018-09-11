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

    def draw_divider(style_name, y)
      style = STYLES[style_name]
      raise "Style not found: '#{style}'" if style.nil?

      setpos(y, 0)
      addstr(style[8])
      (maxx - 2).times { addstr(style[9]) }
      addstr(style[10])
    end
  end
end
