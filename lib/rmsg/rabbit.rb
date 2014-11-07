module Rmsg
  class Rabbit
    # @return [Bunny::Connection]
    attr_reader :connection
    # @return [Bunny::Channel]
   attr_reader  :channel

   # On creation holds references to RabbitMQ via
   # a Bunny connection and a Bunny channel.
    def initialize
      @connection = Bunny.new
      @connection.start
      @channel = @connection.create_channel
    end

    # Close the channel and the connection to RabbitMQ.
    def close
      @channel.close
      @connection.close
    end
  end
end
