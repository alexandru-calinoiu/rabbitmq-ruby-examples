require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
q = ch.queue('hello', durable: true)

p "[*] Waiting for messages in #{q.name}. To exit press CTRL+C"
q.subscribe(block: true) do |delivery_info, properties, body|
	p "[x] Received #{body}"

	# cancel the consumer to exit
	delivery_info.consumer.cancel
end