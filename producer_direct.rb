require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
exchange = ch.direct('direct_logs')
severity = ARGV.shift || 'info'
msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')

exchange.publish(msg, routing_key: severity)
p "[x] Sent '#{msg}'"

conn.close
