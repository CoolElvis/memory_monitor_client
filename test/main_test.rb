require_relative 'test_helper'

class MainTest < MiniTest::Test

  def setup
  end

  def test_main
    server = UDPSocket.new
    server.bind('127.0.0.1', 5555)
    config = { host: '127.0.0.1', port: 5555, period: 1 }
    MemoryMonitorClient.run(config)

    sleep 0.1
    data = server.recvfrom(1000)

    assert_equal(JSON.parse(data.first)['rss'], MemoryMonitorClient.rss)
  end

end
