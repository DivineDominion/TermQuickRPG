{
size: [11, 9],
solids: %Q{█☻▄╥─┌┐└┘│},
layers: [
  ["███▄███▄███",
   "█         █",
   "█   ☻ ☻   █",
   "█  ┌───┐  █",
   "█ ☻│   │  █",
   "█  └╥─╥┘  █",
   "█    ☻    █",
   "█         █",
   "██▁▁███▄███"]
],
player_position: [8, 4],
triggers: {
  [2..3, 8] => -> (ctx) {
    ctx.run do
      open_map "town"
    end
  }
},
flags: { have_pancakes: false },
interactions: {
  [4..6, 6..7] => -> (ctx) {
    ctx.run do
      if !map_flag[:have_pancakes]
        msg "What will we eat today?"
        request_use_item "Give some food:" do |item|
          if item.name == "Pancakes"
            take item
            replace_tile [4,4], "⌾"
            sleep 0.2
            replace_tile [5,4], "⌾"
            sleep 0.2
            replace_tile [6,4], "⌾"
            sleep 0.2
            msg "Great work! Let's dine!"
            map_flag[:have_pancakes] = true
          elsif item.name == "Heart"
            msg "You're disgusting!"
          else
            msg "How would we eat a #{item.name}?"
          end
        end
      end
    end
  }
}
}
