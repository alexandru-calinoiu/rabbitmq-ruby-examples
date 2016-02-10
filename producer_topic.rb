require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
exchange = ch.topic('topic_logs')
topic = ARGV.shift || 'anonymous.info'
msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')

exchange.publish(msg, routing_key: topic)
p "[x] Sent #{topic}:#{msg}"

conn.close