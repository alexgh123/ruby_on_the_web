require 'socket'
require 'json'

class Request
  attr_accessor :method, :path, :protocol, :headers, :params

  def initialize(client)
    @client = client
    @method, @path, @protocol = @client.gets.split(" ")
    @headers  = Hash.new
    @body     = ""
    @params   = Hash.new
    read_headers
    read_body
    read_params
  end

  def to_s
    headers = hash_to_s(@headers)
    params  = hash_to_s(@params)
    %Q{#{@method} #{@path} #{@protocol}\n#{headers}\n\n#{@body}\n\n#{@params}}
  end

  private
  def hash_to_s(h)
    h.map { |k,v| "#{k}: #{v}"}.join("\n")
  end

  def read_headers
    headers = ""
    while line = @client.gets
      headers << line
      break if headers =~ /\r\n\r\n$/
    end
    headers.split("\n")[0...-1].each do |header|
      header_name, header_val = header.split(":").map { |h| h.strip }
      @headers[header_name] = header_val
    end
  end

  def read_body
    @body = @client.read(@headers['Content-Length'].to_i)
  end

  def read_params
    if @method == "POST" && @headers["Content-Type"] == "application/json"
      @params = JSON.parse(@body)
    elsif @method == "GET" && @path.include?("?")
      @path, params = @path.split("?")
      params.split("&").each do |pair|
        param_name, param_value = pair.split("=")
        @params[param_name] = param_value
      end
    end
  end
end


class Response
  def initialize(status, body, content_type="text/html")
    @status  = status
    @headers = {
      "Server"         => "Test Ruby server",
      "Last-Modified"  => Time.now.ctime,
      "Content-Type"   => content_type,
      "Content-Length" => body ? body.length : 0
     }
    @body = body
  end

  def to_s
    headers = @headers.map { |k,v| "#{k}: #{v}"}.join("\n")
    %Q{#{@status}\n#{headers}\n\n#{@body}}
  end
end


class Response200 < Response
  def initialize(body)
    super("HTTP/1.0 200 OK", body)
  end
end


class Response404 < Response
  def initialize
    super("HTTP/1.0 404 Not Found", "Page not Found!")
  end
end


class VikingWebsite
  attr_accessor :templates

  def initialize
    @templates = {
      index:  File.read("index.html"),
      thanks: File.read("thanks.html")
    }
  end

  def render_template(template, params)
    t = @templates[template]
    unless params.empty?
      t.sub("<%= yield %>", params.map { |k,v| "<li>#{k}: #{v}</li>"}.join(""))
    else
      t
    end
  end
end


class Server
  def initialize(website)
    @server  = TCPServer.new("0.0.0.0", 8080)
    @website = website
  end

  def run
    loop do
      client  = @server.accept
      request = Request.new(client)

      case request.method
      when "GET"
        case request.path
        when "/index"
          t = @website.render_template(:index, request.params)
          client.puts Response200.new(t)
        else
          client.puts Response404.new
        end
      when "POST"
        case request.path
        when "/register"
          t = @website.render_template(:thanks, request.params['viking'])
          client.puts Response200.new(t)
        else
          client.puts Response404.new
        end
      end
      client.close
    end
  end
end

s = Server.new(VikingWebsite.new)
s.run