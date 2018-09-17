# TermQuickRPG

Terminal QuickRPG port.

- See [the Gosu port](https://github.com/DivineDominion/quickrpg-clone) of the graphical game from 2001.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'termquickrpg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install termquickrpg

After installing with `gem install`, you can run it from your `PATH` as:

    $ termquickrpg

### Ubuntu Installation Troubleshooting

On a fresh Ubuntu you'll probably need:

    sudo apt install git ruby ruby-dev ruby-bundler build-essential libncurses-dev

Then you should be able to run the ruby scripts at all.

## Local testing

To run the built-in game from this directory without installation, install dependencies and run `exe/termquickrpg`:

    $ bundle
    $ bundle exec exe/termquickrpg

Alternatively:

    $ rake run

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Game scripts

You can write maps to include scriptable content and not just static map data.

- To execute a script when the player _moves onto_ a coordinate, add an entry to the `:triggers` hash. (Key: location of the form `[x, y]`; Value: lambda `-> (ctx) { }`)
- To execute a script when the player _interacts_ with a specific coordinate (e.g. when you placed a decorative thing on the map to mangle with), add an entry to the `:interactions` hash. (Key: location of the form `[x, y]`; Value: lambda `-> (ctx) { }`)
- To have items the player can pick up, add an entry to the `:items` array as a hash of all item initializer parameters. (`{ location: [x, y], char: "†", name: "Dagger", effect: "You stab with your Dagger." }`)
- To have non-player characters to talk to, add an entry to `:characters` array as a hash of all character initializer parameters. (`{ location: [x, y], char: "☻", name: "Bob", talk: -> (ctx, bob) { } }`.

The actual scripts are in the Ruby lambdas. That means they are executable Ruby code: you can do everything you can do in regular Ruby code, like using loops and if-statements.

To access the game engine-specific commands, you get a _script context_ to `#run` the script in as the first parameter of the lambda (named `ctx` in the examples). Wrap your code like in this example:

```ruby
{
interactions: [
  # Location x=10/y=5 in the map
  [10, 5] => -> (ctx) {
    # Regular ruby code could be here
    ctx.run do
      # Custom script commands are available in this block, like:
      msg "Hi!"
    end
  }
], # rest of the map data ...
}
```

Note that scripts accept 1 or 2 parameters. The first one is always the script context. The optional second parameter is the trigger itself. In the case of a character's `talk` script, that would be the character game object itself. You can use that object in your script to change the character's representation on the map or move it around:

```ruby
{
characters: [
  { 
    location: [x, y], char: "☺", name: "Bob", talk: -> (ctx, bob) { 
      ctx.run
        # Use regular script commands
        move bob, :up
        dialogue bob, "Don't touch me!"
        # Access `bob`'s properties and methods to change his face
        bob.replace_char "☹"
      end
    } 
  }, # more character definitions here ...
], # rest of the map data ...
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DivineDominion/termquickrpg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
