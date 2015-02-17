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
      screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name}
      if screen_names.include?(target)
        puts "Trying to send #{target} this direct message:"
        puts message
        message = "d @#{target} #{message}"
        tweet(message)
      else
        raise ArgumentError, "You can only DM yo followers fool!"
      end
  end

  def followers_list
    screen_names = []
    @client.followers.collect {|follower|
      screen_names << @client.user(follower).screen_name
    }
    screen_names
  end

#re followers_list method: why isn't there a variable called followers, or list_of_followers, that's what we want right? screen_name is a word from AIM, this is twitter

  def spam_my_followers(message)
    followers_list.each {|follower|
      dm(follower, message)
    }
  end

#this is how i started to think about it, then i caved and looked at other's work: (this is the begining of the everyones_last_tweet method)
  # def last_tweet_from_each_friend
  #   @client.followers.collect {|follower|
  #     #follower.tweet.last
  #   }
  # end

  def everyones_last_tweet
    #i think this is kinda circular and i need to investigate this method more
    friends = @client.friends
    friends = friends.sort_by { |friend| @client.user(friend).screen_name.downcase}

    friends.each do |friend|
      friend_name = @client.user(friend).screen_name
      friend_last_tweet = @client.user(friend).status.text
      timestamp = @client.user(friend).status.created_at
      timestamp = timestamp.strftime("%A, %b %d")

      puts "\n#{friend_name} wrote at #{timestamp}:"
      puts "#{friend_last_tweet}\n"
    end
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
        when 'spam' then
          spam_my_followers(parts[1..-1].join(" "))
        when 'elt' then everyones_last_tweet
          else
          puts "Sorry, I don't know how to #{command}"
      end
    end
  end

end #ends class

blogger = MicroBlogger.new


blogger.run#("more than 40 test- asodnassdsdsdsdsdsdsdsdsdlansdofansdf;lnasdf;lnads;flnads;lfnasdl;fndlnfal;dsnfal;sdnflads sdksdlsdnkdslkn adflknasdn end here? is this 140 characters?")