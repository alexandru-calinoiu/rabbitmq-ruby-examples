require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
q = ch.queue('hello')

ch.default_exchange.publish('Hello World!', routing_key: q.name)
p "[x] Sent 'Hello World'"

conn.close