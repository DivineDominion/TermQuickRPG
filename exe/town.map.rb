{
size: [27, 17],
solids: %Q{█▟▒╔╣║╠╦╗},
layers: [
  ["███████████████████████████",
   "█                         █",
   "█                         █",
   "█                         █",
   "█           ▒▟██▟▟█▒      █",
   "█           ██░██▟█▟      █", # [14,5]=door
   "█                         █",
   "█                         █",
   "█                         █",
   "█  █▁█▟█       ╔╦╦╦╦╦╦╦╗  █",
   "█              ║*⁑*⁑*⁑*║  █",
   "█              ║⁑█▁█▟*⁑║  █",
   "█              ║*⁑ ⁑*⁑*║  █",
   "█              ╠╦╗ ╔╦╦╦╣  █",
   "█                         █",
   "█                         █",
   "███████████████████████████"],
  ["                         ",
   "                         ",
   "             ▒▒▒▒▒▒      ",
   "            ▒▒▒▒▒▒▒▒     ",
   "           ▒        ▒    ",
   "                         ",
   "                         ",
   "                         ",
   "   ▒▒▒▒▒                 ",
   "                         ",
   "                 ▒▒▒▒    ",
   "                         ",
   "                         ",
   "                         ",
   "                         ",
   "                         ",
   "                         "]
],
player_position: [4, 9],
flags: { door_opened: false },
triggers: {
  [4, 9] => -> (ctx) {
    ctx.run do
      open_map "home"
    end
  },
  [18, 11] => -> (ctx) {
    ctx.run do
      open_map "girlfriend"
    end
  },
  [14, 5] => -> (ctx) {
    ctx.run do
      if map_flag[:door_opened]
        open_map "shop"
      else
        msg "Locked."
      end
    end
  }
},
interactions: {
  [14, 5] => -> (ctx) {
    ctx.run do
      unless map_flag[:door_opened]
        request_use_item "Select item to open door:" do |item|
          case item.name
          when "Dagger"
            flash_screen
            take item
            msg "You broke #{item.name}!"
          when "Mace"
            move player, :down, 0.6
            move player, :down, 0.6
            move player, :down, 0.6
            sleep 1
            move player, :up, 0.1
            move player, :up, 0.1
            sleep 0.1
            flash_screen
            move player, :down, 0.6
            sleep 0.5
            move player, :up, 0.1
            flash_screen
            replace_tile [14,5], "▁"
            sleep 0.2
            msg "You broke the door open!"
            map_flag[:door_opened] = true
          when "Communism"
            msg "#{item.name} usually turns out to be a dead end,", "and we don't want one now, do we?"
          when "Your Heart"
            msg "#{item.name} cannot open this particular door."
          else
            msg "#{item.name} does not work on door."
          end
        end
      end
    end
  }
}
}
