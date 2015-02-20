require 'socket'
webserver = TCPServer.new('127.0.0.1', 7125)#^ connection to server(the fridge) (not webserver(waiter)) #so to connect to net, do i need to have a waiter and a fridge connect?
while (session = webserver.accept) #handles server requests until ctrl c
   session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
   session.print "session.print is: #{session.print}"#alex
   request = session.gets
   session.print "request is #{request}" #alex insertion
   trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
   session.print "trimmedrequest is #{trimmedrequest}" #alex insertion
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