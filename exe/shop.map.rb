{
size: [15, 7],
solids: %Q{█π▄},
layers: [
  ["██▄███░████",
   "█       ▟▘█",
   "█      ▝▘ █",
   "█πππππππππ█████",
   "█π            █",
   "█π            █",
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
characters: [
  { location: [2, 4], char: "☺", name: "Vendor", talk: -> (ctx) {
      ctx.run do
        dialogue "Vendor", "Hello! I'm selling these fine pancakes.", "Do you want to trade anything for a bunch?"
        request_use_item "Trade for pancakes?" do |item|
          case item.name
          when "Communism"
            dialogue "Vendor", "...", "You know I try to run a shop here, right?", "I gotta make me some profits.", "Take that to someone else, wouldcha?"
          when "Your Heart"
            dialogue "Vendor", "That'll do, thanks for your commerce!"
            take item
            give Item.new(char: "⌾", name: "Pancakes", effect: "%s make you feel super!")
          else
            dialogue "Vendor", "What would I need a #{item.name} for?"
          end
        end
      end
    }
  }
]
}
