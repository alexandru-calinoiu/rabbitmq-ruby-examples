require 'bunny'
require 'thread'

class FibonacciClient
	attr_reader :reply_queue, :server_queue, :exchange
	attr_accessor :response, :call_id
	attr_reader :lock, :condition

	def initialize(channel, server_queue)
		@server_queue = server_queue
		@exchange = channel.default_exchange
		@reply_queue = channel.queue('', exclusive: true)

		@lock = Mutex.new
		@condition = ConditionVariable.new
		that = self

		reply_queue.subscribe do |_, properties, payload|
			if properties.correlation_id == that.call_id
				that.response = payload.to_i
				that.lock.synchronize { that.condition.signal }
			end
		end
	end

	def call(n)
		@call_id = "#{rand}"

		exchange.publish(n.to_s,
			routing_key: server_queue,
			correlation_id: call_id,
			reply_to: reply_queue.name)

		lock.synchronize { condition.wait(lock) }
		response
	end
end

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

channel = conn.create_channel
n = ARGV.shift || 30

client = FibonacciClient.new(channel, 'rpc_queue')
p "[x] Requesting fib(#{n})"
response = client.call(n)
p "[.] Get #{response}"

channel.close
conn.close