require "delegate"
require "forwardable"
require "termquickrpg/control/window_registry"
require "termquickrpg/dialogue/dialogue_view"

module TermQuickRPG
  module Dialogue
    class DialogueWindow < SimpleDelegator
      extend Forwardable

      NUM_COLS = 50
      NUM_LINES = 3

      attr_reader :padding
      attr_reader :dialogue_view
      def_delegators :dialogue_view, :name, :name=
      def_delegators :dialogue_view, :visible_lines, :visible_lines=
      def_delegators :dialogue_view, :status, :status=

      def initialize(**attrs)
        padding = { horizontal: 2, vertical: 1 }

        # Override customizations
        attrs[:centered] = :horizontal
        attrs[:width] = NUM_COLS + 2 * padding[:horizontal] + 2 # Borders inclusive
        attrs[:height] = NUM_LINES + 2 * padding[:vertical] + 2
        attrs[:margin] = { bottom: 3 } # Help lines
        attrs[:y] = 1000 # Anchor to bottom edge
        attrs[:border] = :double

        super(Control::WindowRegistry.create_bordered_window(attrs))
        @dialogue_view = DialogueView.new(padding: padding)
        add_subview(dialogue_view)
      end
    end
  end
end
