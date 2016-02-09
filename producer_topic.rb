require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
exchange = ch.topic('topic_logs')
topic = ARGV.shift || 'anonymous.info'
msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')

exchange.publish(msg, routing_key: topic)
p "[x] Sent #{topic}:#{msg}"

conn.close