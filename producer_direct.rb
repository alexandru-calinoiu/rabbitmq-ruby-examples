require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
exchange = ch.direct('direct_logs')
severity = ARGV.shift || 'info'
msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')

exchange.publish(msg, routing_key: severity)
p "[x] Sent '#{msg}'"

conn.close
