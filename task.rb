require 'bunny'

conn = Bunny.new(hostmane: 'http://localhost:15672', user: 'admin', password: 'mypass')
conn.start

ch = conn.create_channel
q = ch.queue('tasks', durable: true)

msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')
q.publish(msg, persistent: true)

p "[x] Sent #{msg}"

