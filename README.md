# KeyMapable

Easily transform keys from one format to another.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'key_mapable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install key_mapable

## A quick example

```ruby
class Espresso
  extend KeyMapable

  define_map(:to_h) do
    key_map(:strength, 'Strength')
    key_map(:temperature, 'Temperature, transform: ->(value) { value.to_i })
    key_value('IsHot') { |espresso| espresso.temperature >= 80 }
    array_key_map(:sips, 'Sips') do
      key_map(:sipper, 'Sipper')
      key_map(:temperature, 'Temperature')
    end
  end
end
```

## Usage

To map keys from one format to another. You must first extend the `KeyMapable`
module. This will add the necessary methods to define a map.

```ruby
class Espresso
  extend KeyMapable
end
```

The `.define_map` method lets you define a method that will return a hash from
the given map rules defined in the block. The following example will map
`#strength` to the key `'Strength'` in the hash returned from `#to_h`.

```ruby
class Espresso
  extend KeyMapable

  attr_accessor :strength

  define_map(:to_h) do
    key_map(:strength, 'Strength')
  end
end
```

You can then use the `#to_h` method like so:
```ruby
espresso = Espresso.new
espresso.strength = 10
espresso.to_h
#=> { 'Strength' => 10 }
```

The map definition can be arbitrarily nested as long as the returned objects
respond to the described methods.
```ruby
define_map(:to_h) do
  key_map(:manufacturer, 'Manufacturer') do
    key_map(:location, 'Location') do
      key_map(:country, 'Country')
    end
  end
end
```

If you wish to transform the value you can provide a third argument which must
be a lambda and return the transformed value.

```ruby
define_map(:to_h) do
  key_map(:temperature, 'Temperature', transform: ->(value) { value.to_i })
end
```

Use `#array_key_map` to define maps over arrays:
```ruby
define_map(:to_h) do
  array_key_map(:sips, 'Sips') do
    key_map(:sipper, 'Sipper')
    key_map(:temperature, 'Temperature')
  end
end
```

Use `#key_value` to define a key that will have a manufactured value. The block
is yielded the subject and must return the manufactured value.

```ruby
define_map(:to_h) do
  key_value('IsHot') { |espresso| espresso.temperature >= 80 }
end
```

By default the object the keys are read on is the object itself. If you want to
use another object you can set the `:subject` keyword to a reader method on the
object.

```ruby
define_map(:to_h, subject: :my_reader) do
  # ...
end
```

Sometimes you do not want to return a hash. Provide the `:resolve` keyword to
transform the resulting hash to your own format.
```ruby
define_map(:to_h, resolve: ->(value) { OpenStruct.new(value)}) do
  # ...
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/key_mapable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
