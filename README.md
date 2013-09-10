# Sidekiq::Daemon

Adds support for running [Sidekiq](https://github.com/mperham/sidekiq) as a daemon on JRuby.

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq-daemon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-daemon

## Usage

If you want to start sidekiq as a background process you can make use of the binary `sidekiq-daemon`.
This is a very slim wrapper for the original `sidekiq` binary that is only used to make sure the required
code for daemonization is loaded. Usage is identicat to the original `sidekiq` binary in every regard.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

This work incorporates the JRuby daemonization code from [Puma](https://github.com/puma/puma) by Evan Phoenix and contributors.

## Maintainers

* [Morton Jonuschat](https://github.com/yabawock)

## License

BSD License

## Copyright

Copyright 2013 Morton Jonuschat
