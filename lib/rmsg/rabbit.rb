module Rmsg
  class Rabbit
    attr_reader :connection, :channel

    def initialize
      @connection = Bunny.new
      @connection.start
      @channel = @connection.create_channel
    end

    def close
      @channel.close
      @connection.close
    end
  end
end
