require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
exchange = ch.fanout('logs')

msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')

exchange.publish(msg)
p "[x] Sent #{msg}"

conn.close