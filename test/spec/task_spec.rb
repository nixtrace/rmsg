require_relative './_init'
require 'open3'

describe 'Task' do
  before do
    @rabbit = Rmsg::Rabbit.new
    @task = Rmsg::Task.new(
      rabbit: @rabbit,
      queue: 'messages'
    )
    @message = {
      id: 1,
      body: 'email body'
    }
  end

  it 'is a tasks handler over RabbitMQ' do
    @task.must_be_instance_of Rmsg::Task
  end

  it 'works in a publisher/consumer scenario' do
    completed_job = ''
    publisher = 'bundle exec ruby test/bin/task_publisher.rb'
    consumer = 'bundle exec ruby test/bin/task_consumer.rb'

    # Start the consumer, wait for it to be up,
    # start the publisher and wait for the message
    # on the consumer side. Process, then kill
    # the long-running consumer.
    Open3.popen3(consumer) do |stdin, stdout, stderr, wait_thr|
      sleep 2
      spawn(publisher)
      completed_job = stdout.gets
      Process.kill('INT', wait_thr.pid)
    end

    eval(completed_job.chomp).must_equal @message
  end

  after do
    @rabbit.close
  end
end
