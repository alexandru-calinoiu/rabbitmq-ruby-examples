require 'bunny'

conn = Bunny.new(hostname: '172.17.0.3')
conn.start

ch = conn.create_channel
q = ch.queue('tasks', durable: true)

msg = ARGV.empty? ? 'Hello world' : ARGV.join(' ')
q.publish(msg, persistent: true)

p "[x] Sent #{msg}"

