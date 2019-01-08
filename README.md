# Sekrat::Warehouse::FileSystem

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sekrat/warehouse/file_system`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sekrat-warehouse-file_system'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sekrat-warehouse-file_system

## Usage

To use this Warehouse with a Sekrat::Manager, you do something like this:

```ruby
require 'sekrat'
require 'sekrat/warehouse/file_system'

base_directory = "/var/lib/secrets"

confidant = Sekrat.manager(
  warehouse: Sekrat::Warehouse::Filesystem.new(basedir: base_directory)
)
```

Now, when you `confidant.put` secrets, they will be saved to the filesystem under the `/var/lib/secrets` directory, and the data within will be encoded as base64 (to get around string/file encoding issues that arose in initial development).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sekrat/sekrat-warehouse-file_system-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sekrat::Warehouse::FileSystem project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sekrat/sekrat-warehouse-file_system-ruby/blob/master/CODE_OF_CONDUCT.md).
