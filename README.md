# Egg

Egg helps prevent code fires! Also he makes it easy to run complex multi-service apps with Docker.

Maintainers:
* [Carl Thuringer](https://github.com/carlthuringer)
* [Jason Sisk](https://github.com/sisk)

This gem is currently heavily focused on Ruby and Rails projects relevant within 
the Belly organization. The eventual goal is for this to become language and 
framework agnostic, though the configuration language will be Ruby. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'egg'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install egg

## Usage
* `init` - Initialize a repo for use with Egg. Creates the `egg_config.rb`
* `readme` - Display the Usage readme
* `setup` - Generates the docker files from the configuration, runs all setup hooks, then boots the application.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bellycard/egg. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0).

