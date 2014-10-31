require_relative './_init'

describe 'Topic' do
  before do
    @rabbit = Rmsg::Rabbit.new
    @topic = Rmsg::Topic.new(
      rabbit: @rabbit,
      topic: 'title'
    )
    @message = {
      id: 1,
      content: 'hello'
    }
    @key = 'users.new'
  end

  it 'is a topics handler over RabbitMQ' do
    @topic.must_be_instance_of Rmsg::Topic
  end

  it 'can publish and read a message with a routing key' do
    @topic.publish(@message, @key)
    @topic.subscribe(@key) do |message|
      p message
      p 'test'
    end
  end
end
