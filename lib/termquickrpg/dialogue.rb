require "termquickrpg/dialogue/dialogue"
require "termquickrpg/dialogue/dialogue_controller"

module TermQuickRPG
  module Dialogue
    def self.show(who, *lines)
      controller = DialogueController.new(Dialogue.new(who, *lines))
      controller.show_dialogue
    end
  end
end
