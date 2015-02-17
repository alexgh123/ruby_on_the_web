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

  def dm(target, message)

    #logic to verify you can DM someone


    puts "Trying to send #{target} this direct message:"
    puts message
    message = "d @#{target} #{message}"
    tweet(message)
  end

  def run
    puts "Welcome to the JSL Twitter Client!"
    command = ""
    while command != "q"
      printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then  tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
          else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end

end #ends class

blogger = MicroBlogger.new


blogger.run#("more than 40 test- asodnassdsdsdsdsdsdsdsdsdlansdofansdf;lnasdf;lnads;flnads;lfnasdl;fndlnfal;dsnfal;sdnflads sdksdlsdnkdslkn adflknasdn end here? is this 140 characters?")