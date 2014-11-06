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
