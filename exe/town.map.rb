{
size: [20, 12],
solids: ["█"],
layers: [
  ["████████████████████",
   "█                  █",
   "█                  █",
   "█                  █",
   "█           █████  █",
   "█           ██░██  █", # [14,5]=door
   "█                  █",
   "█                  █",
   "█                  █",
   "█                  █",
   "█                  █",
   "████████████████████"],
  ["                    ",
   "                    ",
   "              ▒     ",
   "             ▒▒▒    ",
   "                    ",
   "                    ",
   "                    ",
   "                    ",
   "                    ",
   "                    ",
   "                    ",
   "                    "]
],
items: [
  { location: [8, 6], char: "♥", name: "Heart", effect: "%s healed %s!"},
  { location: [4, 4], char: "¶", name: "Mace", effect: "You swung your %s - and it broke!" }
],
player_position: [9, 5],
flags: { door_opened: false },
triggers: {
  [14, 5] => -> (ctx) {
    ctx.run do
      if map_flags[:door_opened]
        open_map "house.map.rb"
      else
        move player, :down, 0.6
        move player, :down, 0.6
        move player, :down, 0.6
        sleep 1
        move player, :up, 0.1
        move player, :up, 0.1
        sleep 0.1
        flash_screen
        sleep 0.2
        msg "You broke the door open!"
        map_flags[:door_opened] = true
      end
    end
  }
}
}
