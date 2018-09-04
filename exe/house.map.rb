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
},
interactions: {
  [1..7, 3] => -> (ctx) {
    ctx.run do
      msg "Hello! I'm selling these fine pancakes."
      request_use_item "Trade for pancakes?" do |item|
        if item.name == "Heart"
          msg "That'll do, thanks for your commerce!"
          take item
          give Item.new(char: "⌾", name: "Pancakes", effect: "%s make you feel super!")
        else
          msg "What would I need a #{item.name} for?"
        end
      end
    end
  }
}
}
