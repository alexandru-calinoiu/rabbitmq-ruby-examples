require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
q = ch.queue('hello', durable: true)

ch.default_exchange.publish('Hello World!', routing_key: q.name)
p "[x] Sent 'Hello World'"

conn.close