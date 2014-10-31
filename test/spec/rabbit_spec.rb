require_relative './_init'

describe 'Rabbit' do
  before do
    @rabbit = Rmsg::Rabbit.new
  end

  it 'represents RabbitMQ' do
    @rabbit.must_be_instance_of Rmsg::Rabbit
  end

  it 'has an open connection' do
    @rabbit.connection.open?.must_equal true
  end

  it 'has an open channel' do
    @rabbit.channel.open?.must_equal true
  end

  it 'can close its channel and connection' do
    @rabbit.close
    @rabbit.channel.closed?.must_equal true
    @rabbit.connection.closed?.must_equal true
  end
end
