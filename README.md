# Rmsg

RabbitMQ messaging in Ruby, with topics and tasks. A thin, minimal layer on top of [Bunny](https://github.com/ruby-amqp/bunny).

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

Rmsg supports messaging following the pub/sub over topics pattern and the tasks (work queues) pattern. Publishers are non-blocking since the typical scenario is publishing a message from a web app. Topic Subscribers and Task Consumers are blocking, long-running processes. You should run them as multiple independent processes using a supervisor like [runit](http://smarden.org/runit/).

## Topics.

Scenario: you have several independent services running. One of them holds users credentials. When an user changes his global API key you want to inform all interested services that the key has changed. Services choose to communicate over the "services" topic. You can have multiple publishers and multiple subscribers for the same topic and routing key.

### Subscriber.

A topic subscriber is a service listening to the "services" topic, for messages published with the "users.key_changed" routing key.

```ruby
#!/usr/bin/env ruby

require 'rmsg'

rabbit = Rmsg::Rabbit.new
services = Rmsg::Topic.new(rabbit: rabbit, topic: 'services')

services.subscribe('users.key_changed') do |message|
   p message
end
```

You can also have a subscriber listening to all events related to users, not only to a specific event, by changing the routing key of the subscriber to:

```ruby
services.subscribe('users.*') do |message| ...
```

### Publisher.

A topic publisher is a service publishing the message to inform all other services that the event 'users.key_changed' has just happened.

```ruby
#!/usr/bin/env ruby

require 'rmsg'

message = {
  id: 1,
  key: 'xxxccc'
}
key = 'users.key_changed'

rabbit = Rmsg::Rabbit.new
services = Rmsg::Topic.new(rabbit: rabbit, topic: 'services')

services.publish(message, key)

rabbit.close
```

## Tasks.

Scenario: you have many email messages coming through a web API and you want to enqueue them as fast as possible, processing them at a later time using distributed consumers. Task publishers and consumers use durable queues and persistent messages, to ensure that tasks will survive a RabbitMQ restart. Consumers will send a manual ack after processing a task, in order to avoid losing tasks if a consumer crashes while processing a task. Tasks will be distributed to consumer processes with a simple round-robin schedule, one task per consumer.

### Consumer.

A task consumer is a process that grabs a task from the tasks queue and performs some work with it.

```ruby
#!/usr/bin/env ruby

require 'rmsg'

rabbit = Rmsg::Rabbit.new
messages = Rmsg::Task.new(rabbit: rabbit, queue: 'messages')

messages.subscribe do |message|
  sleep 1
  p message
end
```

### Publisher.

A task publisher is a process that publishes a task on a tasks queue as fast as possible.

```ruby
#!/usr/bin/env ruby

require 'rmsg'

rabbit = Rmsg::Rabbit.new
messages = Rmsg::Task.new(rabbit: rabbit, queue: 'messages')

message = {
  id: 1,
  body: 'email body'
}
messages.publish(message)

rabbit.close
```

## Tests.

- Be sure you have a local RabbitMQ server running.

- run tests with:
```ruby
bundle exec rake test:spec
```

## Contributing.

1. Fork it ( https://github.com/badshark/rmsg/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License.

[MIT](LICENSE.txt)
