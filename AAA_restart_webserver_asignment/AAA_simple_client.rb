# require 'socket'

# hostname = 'localhost' #instead of www.google.com
# port = 2000

# s = TCPSocket.open(hostname, port)

# while line = s.gets
#   puts line.chop
# end
# s.close



#alt version below



# require 'socket'

# host = 'www.tutorialspoint.com'     # The web server
# port = 80                           # Default HTTP port
# path = "/index.htm"                 # The file we want

# # This is the HTTP request we send to fetch a file
# request = "GET #{path} HTTP/1.0\r\n\r\n"

# socket = TCPSocket.open(host,port)  # Connect to server
# socket.print(request)               # Send request
# response = socket.read              # Read complete response
# # Split response at first blank line into headers and body
# headers,body = response.split("\r\n\r\n", 2)
# print body                          # And display it

require 'net/http'

host = 'www.tutorialspoint.com'
path = '\index.htm'
http = Net::HTTP.new(host)
headers, body = http.get(path)
if headers.code == "200"
  print body
else
  puts "#{headers.code} eh... #{headers.message}"
end