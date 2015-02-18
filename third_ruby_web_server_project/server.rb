require 'socket'
webserver = TCPServer.new('127.0.0.1', 7125)#^ connection to server(the fridge) (not webserver(waiter)) #so to connect to net, do i need to have a waiter and a fridge connect?
while (session = webserver.accept)
   session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
   request = session.gets
   trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
   filename = trimmedrequest.chomp
   if filename == ""
      filename = "index.html"
   end
   begin
      displayfile = File.open(filename, 'r')
      content = displayfile.read()
      session.print content
   rescue Errno::ENOENT
      session.print "zombie File not found"
   end
   session.close
end