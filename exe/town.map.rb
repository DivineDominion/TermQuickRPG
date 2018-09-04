{
size: [25, 12],
solids: ["█", "▟", "▒"],
layers: [
  ["█████████████████████████",
   "█                       █",
   "█                       █",
   "█                       █",
   "█           ▒▟██▟▟█▒    █",
   "█           ██░██▟█▟    █", # [14,5]=door
   "█                       █",
   "█                       █",
   "█                       █",
   "█  █▁█▟█                █",
   "█                       █",
   "█████████████████████████"],
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
   "                         ",
   "                         "]
],
items: [
  { location: [8, 6], char: "♥", name: "Heart", effect: "%s heals you!"},
  { location: [4, 4], char: "¶", name: "Mace", effect: "You swing your %s." }
],
player_position: [4, 9],
flags: { door_opened: false },
triggers: {
  [4, 9] => -> (ctx) {
    ctx.run do
      open_map "home"
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
          if item.name == "Mace"
            move player, :down, 0.6
            move player, :down, 0.6
            move player, :down, 0.6
            sleep 1
            move player, :up, 0.1
            move player, :up, 0.1
            sleep 0.1
            flash_screen
            replace_tile [14,5], "▁"
            sleep 0.2
            msg "You broke the door open!"
            map_flag[:door_opened] = true
          else
            msg "#{item.name} does not work on door."
          end
        end
      end
    end
  }
}
}
