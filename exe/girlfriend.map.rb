{
size: [6, 7],
solids: %Q{█▄},
layers: [
  ["███▄██",
   "█    █",
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
characters: [
  { location: [1, 1], char: "☺", name: "Girlfriend", talk: -> (ctx, gf) {
      ctx.run do
        case map_flag[:times_spoken]
        when 0
          dialogue gf, "Maybe I don't want to talk to you now ..."
        when 1
          dialogue gf, "I told you to perhaps stop."
        when 2
          dialogue gf, "I warn you one last time."
        when 3
          dialogue gf, "You know ...", "I don't want to be with you any more."

          flash_screen 0.15
          sleep 0.15

          flash_screen 0.15
          move player, :down
          gf.replace_char "☃"
          gf.change_name "Ex-Girlfriend"
          sleep 0.15

          flash_screen 0.15
          move player, :down
          sleep 0.5

          give Item.new(char: "♥", name: "Your Heart", effect: "%s is aching."), "Got Your Heart back!"
        when 4
          dialogue gf, "What?"
        when 5,7,9
          dialogue gf, "..."
        when 6
          dialogue gf, "It's over."
        when 8
          dialogue gf, "Deal with it."
        when 10
          dialogue gf, "Ok, one last kiss for your effort."
          flash_screen 0.3
          give Item.new(char: "☭", name: "Communism", effect: "You get what you deserve.")
        else
          msg "Sometimes, there's nothing people have to tell each other anymore."
        end
        map_flag[:times_spoken] += 1
      end
    }
  }
]
}
