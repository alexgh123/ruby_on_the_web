require 'net/http'
require 'json'

class Browser
  def initialize
    puts "Simple Browser"
    @get_uri = URI("http://0.0.0.0:8000/index")
    @post_uri = URI("http://0.0.0.0:8000")
  end
end