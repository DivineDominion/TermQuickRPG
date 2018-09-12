require "curses"

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
