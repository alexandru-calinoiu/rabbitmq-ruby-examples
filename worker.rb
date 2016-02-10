require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
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
