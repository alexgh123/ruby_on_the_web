require 'jumpstart_auth'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
    if message.length > 140
      raise ArgumentError, "Tweets must be 140 characters or less"
    else
    @client.update(message)
    end
  end

end #ends class

blogger = MicroBlogger.new


blogger.tweet("more than 40 test- asodnassdsdsdsdsdsdsdsdsdlansdofansdf;lnasdf;lnads;flnads;lfnasdl;fndlnfal;dsnfal;sdnflads sdksdlsdnkdslkn adflknasdn end here? is this 140 characters?")