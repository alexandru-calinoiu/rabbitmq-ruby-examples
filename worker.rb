require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
ch.prefetch(1)
q = ch.queue('tasks', durable: true)

q.subscribe(manual_ack: true, block: true) do |delivery_info, _, body|
	puts "[x] Received #{body}"
	sleep body.count(".").to_i
	puts "[x] Done"

	ch.ack(delivery_info.delivery_tag)
end
