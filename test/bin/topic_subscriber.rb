#!/usr/bin/env ruby

require 'rmsg'

rabbit = Rmsg::Rabbit.new
services = Rmsg::Topic.new(rabbit: rabbit, topic: 'services')

services.subscribe('users.key_changed') do |message|
   p message
end
