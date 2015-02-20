require 'socket'

hostname = 'localhost' #instead of www.google.com
port = 2000

s = TCPSocket.open(hostname, port)

while line = s.gets
  puts line.chop
end
s.close