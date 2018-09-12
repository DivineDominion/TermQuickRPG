require "termquickrpg/dialog_box/dialog_box_window"
require "termquickrpg/dialog_box/dialog_box_view"
require "termquickrpg/dialog_box/dialog_box_controller"

module TermQuickRPG
  module DialogBox
    def self.pick_option(*lines, options)
      options = if options.is_a?(Hash)
                  options
                elsif options.is_a?(Array)
                  options.map.with_index { |opt, i| [i, opt] }.to_h
                else
                  # Wrap single string option in hash
                  { close: options.to_s }
                end
      dialog_box_window = DialogBox::DialogBoxWindow.new(lines, options)
      controller = DialogBox::DialogBoxController.new(options, dialog_box_window)
      controller.pick_option
    end
  end
end
