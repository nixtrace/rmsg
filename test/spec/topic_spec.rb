require_relative './_init'
require 'open3'

describe 'Topic' do
  before do
    @rabbit = Rmsg::Rabbit.new
    @topic = Rmsg::Topic.new(
      rabbit: @rabbit,
      topic: 'messages'
    )
    @message = {
      id: 1,
      key: 'xxxccc'
    }
  end

  it 'is a topics handler over RabbitMQ' do
    @topic.must_be_instance_of Rmsg::Topic
  end

  it 'works in a single publisher, single subscriber scenario' do
    read_message = ''
    publisher = 'bundle exec ruby test/bin/topic_publisher.rb'
    subscriber = 'bundle exec ruby test/bin/topic_subscriber.rb'

    # Start the subscriber, wait for it to be up,
    # start the publisher and wait for the message
    # on the subscriber side. Then kill
    # the long-running subscriber.
    Open3.popen3(subscriber) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      spawn(publisher)
      read_message = stdout.gets
      Process.kill('INT', wait_thr.pid)
    end

    output = eval read_message.chomp
    output.must_equal @message
  end

  after do
    @rabbit.close
  end
end
