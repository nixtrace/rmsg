module Rmsg
  class Task
    def initialize(params)
      @rabbit = params[:rabbit]
      @queue = @rabbit.channel.queue(params[:queue], durable: true)
    end

    def publish(message)
      @queue.publish(message.to_json, presistent: true)
    end

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
