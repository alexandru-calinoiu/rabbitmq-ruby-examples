require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
exchange = ch.fanout('logs')

msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')

exchange.publish(msg)
p "[x] Sent #{msg}"

conn.close