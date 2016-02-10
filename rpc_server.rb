require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

channel = conn.create_channel

class FibonacciServer
	attr_reader :channel

	def initialize(channel)
		@channel = channel
	end

	def start(queue_name)
		queue = channel.queue(queue_name)
		exchange = channel.default_exchange

		queue.subscribe(block: true) do |_, properties, payload|
			n = payload.to_i
			p "[.] Calcullating fib(#{n})"
			response = self.class.fib(n)

			exchange.publish(response.to_s, routing_key: properties.reply_to, correlation_id: properties.correlation_id)
		end
	end

	def self.fib(n)
		case n
		when 0 then 0
		when 1 then 1
		else
			@hash ||= {}
			@hash[n - 1] ||= fib(n - 1)
			@hash[n - 2] ||= fib(n - 2)
			@hash[n - 1] + @hash[n - 2]
		end
	end
end

begin
  server = FibonacciServer.new(channel)
  p "[x] Awaiting RPC requests"
  server.start("rpc_queue")
rescue Interrupt => _
  channel.close
  conn.close
end