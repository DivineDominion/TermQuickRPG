{
size: [20, 12],
solids: ["█"],
layers: [
  ["████████████████████",
   "█                  █",
   "█                  █",
   "█                  █",
   "█           █████  █",
   "█           ██░██  █", # [13,5]
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
      open_map "house.map.rb"
    end
  }
}
}
