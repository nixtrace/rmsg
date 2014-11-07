module Rmsg
  # Task handles publishing tasks and processing them.
  class Task
    # When initializing a task handler, the queue
    # will be declared durable, to survive RabbitMQ restarts.
    # @param params [Hash]
    # * :rabbit [Rmsg::Rabbit] Example: Rmsg::Rabbit.new
    # * :queue [String] Example: 'messages'
    def initialize(params)
      @rabbit = params[:rabbit]
      @queue = @rabbit.channel.queue(params[:queue], durable: true)
    end

    # Publish a message in the tasks queue.
    # It is marked a persistent to survive RabbitMQ restarts.
    # @param message [Hash] The message to be consumed.
    def publish(message)
      @queue.publish(message.to_json, presistent: true)
    end

    # Subscribe to the tasks queue.
    # Subscribing happens by continuously blocking the current process.
    # It is specifically designed for long running processes.
    # When receiving INT it will gracefully close.
    # Consumer processes have a prefetch value of 1 for round-robin distribution.
    # Consumer processes will send a manual ack after processing, to avoid losing tasks.
    # @yield message [Hash] A block to process the message received.
    def subscribe
      @rabbit.channel.prefetch(1)
      begin
        @queue.subscribe(block: true, manual_ack: true) do |delivery_info, metadata, payload|
          message = JSON.parse(payload, symbolize_names: true)
          yield message
          @rabbit.channel.ack(delivery_info.delivery_tag)
        end
      rescue Interrupt => _
        @rabbit.close
      end
    end
  end
end
