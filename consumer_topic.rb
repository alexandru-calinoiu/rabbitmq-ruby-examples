require 'bunny'

if ARGV.empty?
	abort "Usage: #{$0} [topic]"
end

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
exchange = ch.topic('topic_logs')
queue = ch.queue('', exclusive: true)

ARGV.each do |severity|
  queue.bind(exchange, routing_key: severity)
end

p '[*] Waiting for logs. To exit press CTR+C'

begin
	queue.subscribe(block: true) do |delivery_info, _, body|
		p "[x] #{delivery_info.routing_key}:#{body}"
	end
rescue Interrupt => _
	ch.close
	conn.close
end
