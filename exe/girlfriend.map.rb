{
size: [6, 7],
solids: %Q{█☃☻▄},
layers: [
  ["███▄██",
   "█☻   █",
   "█    █",
   "█    █",
   "█    █",
   "█    █",
   "█▁▁█▄█"]
],
player_position: [2, 6],
triggers: {
  [1..2, 6] => -> (ctx) {
    ctx.run do
      open_map "town"
    end
  }
},
flags: { times_spoken: 0 },
interactions: {
  [1..2, 1..2] => -> (ctx) {
    ctx.run do
      case map_flag[:times_spoken]
      when 0
        msg "Please, don't talk to me right now."
      when 1
        msg "I told you to stop."
      when 2
        msg "I warn you one last time."
      when 3
        msg "You know ...", "I don't want to be with you any more."

        flash_screen 0.15
        sleep 0.15

        flash_screen 0.15
        move player, :down
        replace_tile [1,1], "☃"
        sleep 0.15

        flash_screen 0.15
        move player, :down
        sleep 1

        give Item.new(char: "♥", name: "Your Heart", effect: "%s is aching."), "Got Your Heart back!"
      when 4
        msg "What?"
      when 5,7,9
        msg "..."
      when 6
        msg "It's over."
      when 8
        msg "Deal with it."
      when 10
        msg "Ok, one last kiss for your effort."
        flash_screen 0.3
        give Item.new(char: "☭", name: "Communism", effect: "You get what you deserve.")
      end
      map_flag[:times_spoken] += 1
    end
  }
}
}
