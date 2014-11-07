#!/usr/bin/env ruby

require 'rmsg'

rabbit = Rmsg::Rabbit.new
messages = Rmsg::Task.new(rabbit: rabbit, queue: 'messages')

messages.subscribe do |message|
  sleep 1
  p message
end
