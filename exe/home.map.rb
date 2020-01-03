{
size: [11, 9],
solids: %Q{█▄╥─┌┐└┘│},
layers: [
  ["███▄███▄███",
   "█         █",
   "█         █",
   "█  ┌───┐  █",
   "█  │   │  █",
   "█  └╥─╥┘  █",
   "█         █",
   "█         █",
   "██▁▁███▄███"]
],
player_position: [8, 4],
items: [
  { location: [7, 1], char: "☨", name: "Two-Handed Sword", effect: "You slash with your %s." },
  { location: [8, 1], char: "†", name: "Dagger", effect: "You stab with your %s." },
  { location: [9, 1], char: "¶", name: "Mace", effect: "You swing your %s." },
],
characters: [
  { location: [4, 2], char: "☺", name: "Bar", talk: -> (ctx, dude) {
      ctx.run do
        dialogue dude, *map_flag[:dudes_texts][map_flag[:talked_to_dudes]]
        map_flag[:talked_to_dudes] = [map_flag[:talked_to_dudes] + 1, 3].min
      end
    }
  },
  { location: [6, 2], char: "☺", name: "Foo", talk: -> (ctx, dude) {
      ctx.run do
        dialogue dude, *map_flag[:dudes_texts][map_flag[:talked_to_dudes]]
        map_flag[:talked_to_dudes] = [map_flag[:talked_to_dudes] + 1, 3].min
      end
    }
  },
  { location: [2, 4], char: "☺", name: "Baz", talk: -> (ctx, dude) {
      ctx.run do
        dialogue dude, *map_flag[:dudes_texts][map_flag[:talked_to_dudes]]
        map_flag[:talked_to_dudes] = [map_flag[:talked_to_dudes] + 1, 3].min
      end
    }
  },
  { location: [5, 6], char: "☻", name: "Bob", talk: -> (ctx, bob) {
      ctx.run do
        if !map_flag[:have_pancakes]
          dialogue bob, "We're all super hungry.", "What will we eat today?"
          request_use_item "Give some food:" do |item|
            case item.name
            when "Communism"
              msg "Communism hasn't fed many people with success", "over the course of history.", "You're wary to try your luck on your pals."
            when "Pancakes"
              take item
              replace_tile [4,4], "⌾"
              sleep 0.2
              replace_tile [5,4], "⌾"
              sleep 0.2
              replace_tile [6,4], "⌾"
              sleep 0.2
              dialogue bob, "Great work! Let's dine!"
              map_flag[:have_pancakes] = true
            when "Your Heart"
              dialogue bob, "You're disgusting!"
            else
              dialogue bob, "How would we eat that?!"
            end
          end
        end
      end
    }
  }
],
triggers: {
  [2..3, 8] => -> (ctx) {
    ctx.run do
      open_map "town"
    end
  }
},
flags: {
  have_pancakes: false,
  talked_to_dudes: 0,
  dudes_texts: [
    ["You should talk to Bob about our meal."],
    ["Bob's the dude south of the table. Talk to him."],
    ["This is not south of the table.", "South is farther to the bottom of the screen."],
    ["Gimme food. Talk to Bob. kthxbye"]
  ]
},
interactions: {
  [8, 4] => -> (ctx) {
    ctx.run do
      if map_flag[:have_pancakes]
        msg "Good job!", "Now the day is saved."
        quit
      else
        msg "You are starving. Fetch some food."
      end
    end
  }
}
}
