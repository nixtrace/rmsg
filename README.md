# Rmsg

Topics and Tasks in Ruby over RabbitMQ. A thin, minimal layer on top of [Bunny](https://github.com/ruby-amqp/bunny).

## Installation.

- [Install](https://www.rabbitmq.com/download.html) a local RabbitMQ server and start it:
```sh
# OSX example
$ brew install rabbitmq
$ rabbitmq-server
```

- Add rmsg to your Gemfile:
```ruby
gem 'rmsg'
```

## Usage.

TODO.

## Tests.

- Be sure you have a local RabbitMQ server running.

- run tests with:
```ruby
bundle exec rake test:spec
```

## Contributing

1. Fork it ( https://github.com/badshark/rmsg/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
