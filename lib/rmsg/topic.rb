module Rmsg
  class Topic
    def initialize(params)
      @rabbit = params[:rabbit]
      @exchange = @rabbit.channel.topic(params[:topic])
    end

    def publish(message, key)
      @exchange.publish(message.to_json, :routing_key => key)
    end

    def subscribe(key)
      @queue = @rabbit.channel.queue("", :exclusive => true)
      @queue.bind(@exchange, :routing_key => key)
      begin
        @queue.subscribe(:block => false) do |delivery_info, metadata, payload|
          message = JSON.parse payload
          yield message
        end
      rescue Interrupt => _
        @rabbit.close
      end
    end
  end
end
