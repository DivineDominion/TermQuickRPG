require "delegate"
require "forwardable"
require "termquickrpg/ui/window"
require "termquickrpg/control/window_registry"

module TermQuickRPG
  module DialogBox
    class DialogBoxWindow < SimpleDelegator
      attr_reader :dialog_box_view

      extend Forwardable
      def_delegators :dialog_box_view, :lines, :options, :selected_option, :selected_option=

      def initialize(lines, options, **attrs)
        @dialog_box_view = DialogBoxView.new(lines, options)

        # Override settings with DialogBox defaults
        width, height = @dialog_box_view.intrinsic_size
        attrs = attrs.merge(
          centered: [:horizontal, :vertical],
          border: :single,
          width: width + 2, height: height + 2 # border width
        )
        super(Control::WindowRegistry.create_bordered_window(attrs))
        add_subview(dialog_box_view)
      end
    end
  end
end
