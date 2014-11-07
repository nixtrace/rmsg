module Rmsg
  # Topic handles publishing and subscribing
  # to a topic with a key, over RabbitMQ.
  class Topic
    # @param params [Hash]
    # @option params :rabbit [Rmsg::Rabbit] Example: Rmsg::Rabbit.new
    # @option params :topic [String] Example: 'services'
    def initialize(params)
      @rabbit = params[:rabbit]
      @exchange = @rabbit.channel.topic(params[:topic])
    end

    # Publish a message with a routing key.
    # @param message [Hash] Message to be published.
    # @param key [String] Example: 'users.key_changed'
    # @return [Exchange] The exchange used to publish.
    def publish(message, key)
      @exchange.publish(message.to_json, :routing_key => key)
    end

    # Subscribe to the topic, listening for a specific key.
    # Subscribing happens by continuously blocking the current process.
    # It is specifically designed for long running processes.
    # When receiving INT it will gracefully close.
    # @param key [String] Example: 'users.key_changed'
    # @yieldparam message [Hash] The message received, to be processed within the block.
    def subscribe(key)
      @queue = @rabbit.channel.queue("", :exclusive => true)
      @queue.bind(@exchange, :routing_key => key)
      begin
        @queue.subscribe(:block => true) do |delivery_info, metadata, payload|
          message = JSON.parse(payload, symbolize_names: true)
          yield message
        end
      rescue Interrupt => _
        @rabbit.close
      end
    end
  end
end
