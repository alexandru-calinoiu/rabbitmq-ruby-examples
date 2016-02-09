require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
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