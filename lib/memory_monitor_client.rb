require 'memory_monitor_client/version'
require 'json'
require 'socket'

module MemoryMonitorClient

  def self.run(config, &block)
    Thread.new do
      socket = UDPSocket.new

      loop do
        if block_given?
          data = block.call(collect_data).merge(collect_data)
        else
          data = collect_data
        end

        socket.send(JSON.dump(data), 0, config[:host], config[:port])
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
    `ps -o rss #{Process.pid}`.split("\n").last.to_i / 1024
  end

  def self.gc_stat
    GC.stat
  end

end
