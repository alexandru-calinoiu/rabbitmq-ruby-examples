require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
q = ch.queue('hello', durable: true)

p "[*] Waiting for messages in #{q.name}. To exit press CTRL+C"
q.subscribe(block: true) do |delivery_info, properties, body|
	p "[x] Received #{body}"

	# cancel the consumer to exit
	delivery_info.consumer.cancel
end