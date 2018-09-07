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
        dialogue "Girlfriend", "Maybe I don't want to talk to you now ..."
      when 1
        dialogue "Girlfriend", "I told you to perhaps stop."
      when 2
        dialogue "Girlfriend", "I warn you one last time."
      when 3
        dialogue "Girlfriend", "You know ...", "I don't want to be with you any more."

        flash_screen 0.15
        sleep 0.15

        flash_screen 0.15
        move player, :down
        replace_tile [1,1], "☃"
        sleep 0.15

        flash_screen 0.15
        move player, :down
        sleep 0.5

        give Item.new(char: "♥", name: "Your Heart", effect: "%s is aching."), "Got Your Heart back!"
      when 4
        dialogue "Ex-Girlfriend", "What?"
      when 5,7,9
        dialogue "Ex-Girlfriend", "..."
      when 6
        dialogue "Ex-Girlfriend", "It's over."
      when 8
        dialogue "Ex-Girlfriend", "Deal with it."
      when 10
        dialogue "Ex-Girlfriend", "Ok, one last kiss for your effort."
        flash_screen 0.3
        give Item.new(char: "☭", name: "Communism", effect: "You get what you deserve.")
      end
      map_flag[:times_spoken] += 1
    end
  }
}
}
