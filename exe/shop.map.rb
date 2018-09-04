{
size: [15, 7],
solids: %Q{█☻▄},
layers: [
  ["██▄███░████",
   "█       ▟▘█",
   "█   ☻  ▝▘ █",
   "███████████████",
   "█             █",
   "█             █",
   "███▁▁███▄███▄██"]
],
player_position: [4, 6],
triggers: {
  [3..4, 6] => -> (ctx) {
    ctx.run do
      open_map "town"
    end
  }
},
interactions: {
  [1..7, 4] => -> (ctx) {
    ctx.run do
      msg "Hello! I'm selling these fine pancakes."
      request_use_item "Trade for pancakes?" do |item|
        case item.name
        when "Communism"
          msg "You know I try to run a shop here, right?", "I have kids and family to care for ...", "Get lost!"
        when "Your Heart"
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
