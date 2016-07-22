require 'memory_monitor_client/version'
require 'json'

module MemoryMonitorClient

  def self.run(config)
    Thread.new do
      socket = UDPSocket.new
      socket.connect(config[:host], config[:port])

      loop do
        socket.send(JSON.dump(collect_data), 0)
        sleep config[:period]
      end
    end
  end

  def self.collect_data
    {
      time_stamp: Time.now,
      rss: rss,
      gc_stat: gc_stat,
      pid: Process.pid
    }
  end

  def self.rss
    `ps -o rss #{Process.pid}`.split("\n").last.to_i / 1000
  end

  def self.gc_stat
    GC.stat
  end

end
