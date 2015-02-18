#allegedly this does the same as the mini_web_browser.rb, but i can't get it to do that
#this is a cleint

require 'net/http'
host = 'www.tutorialspoint.com'
path = '/index.htm'

http = Net::HTTP.new(host)
headers,body = http.get(path)
if headers.code == "200"
  print body #i did some debugging, this code is right, but the body variable isn't pulling anything, in the mini_web_browser.rb file, body prints the body
else
  puts "#{headers.code} #{headers.message}"
end
