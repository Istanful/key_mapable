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

## Usage

```ruby
class MyClass
  extend KeyMapable

  # Define a method called `#to_h` that use the provided map. The keys
  # will be accessed on the provided subject. Transform the resulting hash
  # with the provided lambda.
  define_map(:to_h, resolve: ->(val) { val }, subject: :my_reader) do
    # Map the value of `#name` to the key 'Name'.
    key_map(:name, 'Name')

    # Map the value of `#maybe_value` to the key 'GuaranteedValue'.
    # Transform the value by calling `#to_s` first.
    key_map(:maybe_value, 'GuaranteedValue', &:to_s)

    # Map the key 'Name' to the value provided by the block.
    key_value('AConstant') { 'Foo' }

    # Map every item returned from `#rows`.
    array_key_map(:rows, 'Rows') do
      # Map the value of `#id` to the key 'Id'.
      key_map(:id, 'Id')
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/key_mapable.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
