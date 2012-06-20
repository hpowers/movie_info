require 'nokogiri'
require 'open-uri'

class Imdb  
  def initialize(name)
    search_for = URI.escape(name)
    
    search_url = "http://www.google.com/search?q=#{search_for}+imdb&btnI=3564"

    @search_data = Nokogiri::HTML(open(search_url))
  end

  def title
    title = @search_data.at_css('#title-overview-widget h1.header').text.strip

    rem_title = @search_data.at_css('#title-overview-widget h1.header .nobr')
                            .text.strip

    title.gsub(rem_title,'').strip
  end

  def release
    release_date = @search_data.at_css('.infobar .nobr').text.strip
    
    Date.parse(release_date)
  end

  def length
    @search_data.at_css('.infobar').text.strip.match(/\d+/)[0].to_i
  end

  def viewer_score
    viewer_score = @search_data
                  .at_css('#title-overview-widget .star-box-giga-star')

    (viewer_score.text.strip.to_f * 10).to_i
  end

  def metacritic_score
    metacritic = nil
    @search_data.css('.star-box-details a').each do |link|
      if link[:href]=="criticreviews" && link.text.strip.match(/\/100/)
        metacritic = link.text.strip.to_i
        return metacritic
      end
    end
    return metacritic
  end

  def movie_meter
    # search ranking on imdb

    begin
      @search_data.at_css('a#meterRank.top100').text.strip
    rescue NoMethodError => e
      0
    end
    
  end

  def budget
    budget = nil
    @search_data.css('#maindetails_center_bottom .txt-block').each do |block|

      if block.at_css('h4.inline')
        if block.at_css('h4.inline').text.strip == "Budget:"
          budget = block.text.strip.gsub(/\D/,'').to_i
          return budget
        end
      end
    end
    return budget    
  end

  def star_power
    # not implemented
    # average power rating of top 2 billed stars
  end
end

def format_n(number)
  number.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
end

puts "movie title?"
search_for = gets.chomp

movie = Imdb.new(search_for)

puts "#{movie.title}:"
puts "  release date: #{movie.release}"
puts "  length: #{movie.length} mins\n"
puts "  viewer score: #{movie.viewer_score}"
puts "  metacritic: #{movie.metacritic_score}\n"
puts "  movie_meter: #{movie.movie_meter}"
puts "  budget: #{format_n(movie.budget)}"