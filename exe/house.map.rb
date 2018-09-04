{
size: [9, 6],
solids: ["█"],
layers: [
  ["██████░██",
   "█   ☻   █",
   "█████████",
   "█       █",
   "█       █",
   "███▁▁████"],
],
player_position: [4, 5],
triggers: {
  [3..4, 5] => -> (ctx) {
    ctx.run do
      leave_map
    end
  }
}
}
