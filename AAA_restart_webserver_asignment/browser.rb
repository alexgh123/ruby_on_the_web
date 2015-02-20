require 'net/http'
require 'json'

class Browser
  def initialize
    puts "Simple Browser"
    @get_uri = URI("http://0.0.0.0:8080/index")
    @post_uri = URI("http://0.0.0.0:8080/register")
  end

  def run
    loop do
      response = nil
      print "enter g(et) or p(ost) to choose the type of request or q to exit: "
      request_type = gets.chomp.downcase
      if request_type =~/^g(et)?/
        response = get
      elsif request_type =~ /^p(ost)?$/
        puts "Please register for a ride"
        print "Enter name: "
        name = gets.chomp
        print "Enter email: "
        email = gets.chomp
        params = viking_params(name, email)
        response = post(params)
      elsif request_type =~ /^q(uit)?$/
        puts "Bye"
        exit
      else
        puts "Unknown command: #{request_type}"
      end
      display_response(response) if response
    end
  end

  private
  def viking_params(name, email)
    { 'viking' => { 'name' => name, 'email' => email }}
  end

  def display_response(response)
    puts response.body
    puts '-' * 80
  end

  def get
    response = Net::HTTP.get_response(@get_uri)
    display_response(response)
  end

  def post(params)

    params = params.to_json

    http = Net::HTTP.new(@post_uri.host, @post_uri.port)

    request = Net::HTTP::Post.new(@post_uri.request_uri)
    request.body = params

    request["Content-Type"] = "application/json"
    request["Content-Length"] = params.length

    response = http.request(request)
    display_response(response)
  end
end

b = Browser.new
b.run