require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
exchange = ch.fanout('logs')
queue = ch.queue('', exclusive: true)

queue.bind(exchange)

p '[*] Waiting for logs. To exit press CTRL+C'

begin
	queue.subscribe(block: true) do |_, _, body|
		p "[x] #{body}"
	end
rescue Interrupt => _
	ch.close
	conn.close
end