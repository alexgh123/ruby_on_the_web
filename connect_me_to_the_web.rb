# require 'net/http'

# def get_web_document(url)
#   uri = URI.parse(url)
#   response = Net::HTTP.get_response(uri)

#   case response
#   when Net::HTTPSuccess
#     return response.body
#   when Net::HTTPRedirection
#     return get_web_document(response['Location'])
#   else
#     return nil
#   end
# end

# puts get_web_document('http://www.rubyinside.com/test.txt')
# puts get_web_document('http://www.rubyinside.com/non-existent')
# puts get_web_document('http://www.rubyinside.com/redirect-test')

# require 'net/http'

# url = URI.parse('http://browserspy.dk/password-ok.php')

# Net::HTTP.start(url.host, url.port) do |http|
#   req = Net::HTTP::Get.new(url.path)
#   req.basic_auth('test', 'test')
#   puts http.request(req).body
# end

# require 'net/http'

# url = URI.parse('http://www.rubyinside.com/test.cgi')

# response = Net::HTTP.post_form(url, {'name' => 'David', 'age' => '24'})
# puts response.read
# p '---------------------------'
# # puts response.instance_variables
# p '---------------------------'
# # puts response.public_method
# #^i was messing around with how i can use the objects i receive. .methods on the object does in fact work


# require 'net/http'
# url = URI.parse('http://www.rubyinside.com/test.cgi')

# Net::HTTP.start(url.host, url. port) do |http|
#   req = Net::HTTP::Post.new(url.path)
#   req.set_form_data({'name'=>'David', 'age' => '24'})
#   puts http.request(req).body
# end

# require 'net/http'

# web_proxy = Net::HTTP::Proxy('your.proxy.hostname.or.ip', 8080)

# url = URI.parse('http://www.rubyinside.com/test.txt')

# web_proxy.start(url.host, url.port) do |http|
#   req = Net::HTTP::Get.new(url.path)
#   puts http.request(req).body
# end

# require 'net/http'
# require 'net/https'

# url = URI.parse('https://eample.com')

# http = Net::HTTP.new(url.host, url.port)
# http.use_ssl = true if url.scheme == 'https'

# request = Net::HTTP::Get.new(url.path)
# puts http.request(request).body


# require 'open-uri'

# f = open('http://www.rubyinside.com/test.txt')

# puts "The document is #{f.size} bytes in length"

# f.each_line do |line|
#   puts line
# end


# require 'open-uri'

# f = open('http://www.rubyinside.com/test.txt', {'User_Agent' => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)'})

# puts f.read

require 'rubygems'
require 'markaby'

m = Markaby::Builder.new

m.html do
  head { title 'This is the title'}

  body do
    h1 'Hello world'
    h2 'Sub-heading'
    p %q{This is a pile of stuff showing off Markaby's features}
    h2 'Another sub heading'
    p 'Markaby is good at:'
      ul do
        li 'Generating HTML from Ruby'
        li 'Keeping HTML structured'
        li 'lots more...'
        end
    end
end

puts m