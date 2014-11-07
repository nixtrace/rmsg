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
