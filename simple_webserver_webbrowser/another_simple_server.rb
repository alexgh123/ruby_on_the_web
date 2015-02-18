# Now comes the fun part. Modify your simple server to take the HTTP request from the browser and, if it is a GET request that points to /index.html, send back the contents of index.html.

require 'socket'

#so pretty sure the below should be http

#part of the request line is:

# server = HTTP::GET "http://www.laxpower.com
# "

server = TCPServer.open(2000)

loop {
  client = server.accept
  client.puts(Time.now.ctime)
  client.puts "Closing the connection, bye!"
  client.close

}