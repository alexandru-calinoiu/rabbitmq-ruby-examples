require 'bunny'

if ARGV.empty?
	abort "Usage: #{$0} [info] [error] [warning]"
end

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
exchange = ch.direct('direct_logs')
queue = ch.queue('', exclusive: true)

ARGV.each do |severity|
	queue.bind(exchange, routing_key: severity)
end

p '[*] Waiting for messages'

begin
	queue.subscribe(block: true) do |delivery_info, _, body|
		p "[x] #{delivery_info.routing_key}:#{body}"
	end
rescue Interrupt => _
	ch.close
	conn.close
end