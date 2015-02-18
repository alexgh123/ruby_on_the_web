#most basic iteration I've done before, i just fire up the server, then run this command (curl --verbose -XGET http://localhost:2345/anything) in another shell/terminal window

=begin
require 'socket'

server = TCPServer.new('localhost', 2345)

loop do
  socket = server.accept
  request = socket.gets
  STDERR.puts request

  response = "Hello World!\n"

  socket.print  "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: #{response.bytesize}\r\n" +
                "Connection: close \r\n"

  socket.print "\r\n"

  socket.print response

  socket.close

end

=end
#begin second iteration
require 'socket'
require 'uri'
WEB_ROOT = './public'
CONTENT_TYPE_MAPPING = {
  'html' => 'text/html',
  'txt' => 'text/plain',
  'png' => 'image/png',
  'jpg' => 'image/jpeg'
} #honestly, no idea what that stuff ^ does, presumably makes it easier to decipher content types, comments from exercise say it 'maps extensions to their content type' ... :/
DEFAULT_CONTENT_TYPE = 'application/octet-stream'
# ^this is a mystery to me too, author says 'treat as binary data if content type cant be found'. so that seems straighforward, if the hash can't cover t, then do this stuff
def content_type(path)
  ext = File.extname(path).split(".").last
  CONTENT_TYPE_MAPPING.fetch(ext, DEFAULT_CONTENT_TYPE)
end
#^ author says: 'helper function parses extension of the requested file then looks up its content type (with the help of the content mapper hash i typed above)'
def requested_file(request_line) #sanitizing inputs so no injection attacks
  request_uri = request_line.split(" ")[1]
  path = URI.unescape(URI(request_uri).path)
  clean = []

  parts = path.split("/")

  parts.each do |part|
    next if part.empty? || parts == '.'
    part == '..' ? clean.pop : clean << part
  end
  File.join(WEB_ROOT, *clean)
end
# ^ 'This helper function parses the Request-Line and generates a path to a file on the server.' so says author
server = TCPServer.new('localhost', 2345)
loop do
  socket = server.accept
  request_line = socket.gets
  STDERR.puts request_line
  path = requested_file(request_line)

  path = File.join(path, 'index.html') if File.directory?(path) #no ending in file name just goes straight to index page
  #this is the link to the external page, or in the current case, the index.html


  if File.exist?(path) && !File.directory?(path)
    File.open(path, "rb") do |file|
      socket.print  "HTTP/1.1 200 ok\r\n" +
                    "Content-Type: text/plain\r\n" +
                    "Content-Length: #{file.size}\r\n" +
                    "Connection: close \r\n"
      socket.print  "\r\n"

      IO.copy_stream(file, socket)
    end
  else
    message = "IDIOT! File not found\n"

    socket.print  "HTTP/1.1 404 Not Found\r\n" +
                  "Content-Type: text/plain\r\n" +
                  "Content-Length: #{message.size}\r\n" +
                  "Connection: close \r\n"

    socket.print  "\r\n"

    socket.print message
  end
  socket.close
end