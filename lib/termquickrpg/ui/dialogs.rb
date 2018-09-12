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

require "termquickrpg/dialogue"
require "termquickrpg/dialog_box"

module TermQuickRPG
  module UI
    def self.show_dialogue(who, *lines)
      TermQuickRPG::Dialogue.show(who, *lines)
    end

    def self.show_message(*lines)
      show_options(*lines, "Continue")
    end

    def self.show_options(*lines, options)
      TermQuickRPG::DialogBox.pick_option(*lines, options)
    end
  end
end
