require 'nokogiri'
require 'open-uri'

class Tweets
  
  def initialize(name)
    
    search_for = "#{name} site:twitter.com"
    search_for = URI.escape(search_for)

    search_url = "http://www.google.com/search?q=#{search_for}"
    @search_data = Nokogiri::HTML(open(search_url))

  end

  def count
    
    num_tweets = 0
    @search_data.to_s.force_encoding("UTF-8").lines.each do |line|
      
      if line.match(/About.+results/)
        tweets = line.gsub(/\D/,'').to_i
        return tweets
      end
    end

    return num_tweets

  end

end

def format_n(number)
  number.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
end

puts "movie title?"
search_for = gets.chomp
tweets = Tweets.new(search_for)

puts "#{format_n(tweets.count)} tweets"