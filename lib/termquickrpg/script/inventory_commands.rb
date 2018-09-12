require "termquickrpg/control/player"

module TermQuickRPG
  module Script
    module InventoryCommands
      def take(item)
        Control::Player.instance.remove_from_inventory(item)
      end

      def give(item, notify = true)
        Control::Player.instance.take(item)

        if notify.is_a?(String)
          msg notify
        elsif notify
          msg "Obtained #{item.name}!"
        end
      end
    end
  end
end
