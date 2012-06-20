require 'nokogiri'
require 'open-uri'

class Hsx
  def initialize(name)
    search_for = "HSX.com MovieStock : #{name}"
    search_for = URI.escape(search_for)

    search_url = "http://www.google.com/search?q=#{search_for}&btnI=3564"

    @search_data = Nokogiri::HTML(open(search_url))    
  end

  def price
    price = @search_data.at_css('.security_summary p.value').text.strip
    rem_price = @search_data.at_css('.security_summary p.value span').text.strip

    price = price.gsub(rem_price,'').strip
    price.gsub(/[^0-9.]/, "").to_f    
  end

  def gross
    gross = 0

    @search_data.css('.data_column.last tr').each do |block|

      if block.at_css('td.label').text == "Gross:"
        gross = block.at_css('td:nth-child(2)').text.gsub(/\D/,'').to_i

        return gross
      end
    end

    return gross
  end

  def theaters
    theaters = 0

    @search_data.css('.data_column.last tr').each do |block|

      if block.at_css('td.label').text == "Theaters:"
        theaters = block.at_css('td:nth-child(2)').text.to_i

        return theaters
      end
    end

    return theaters
  end
end

def format_n(number)
  number.to_s.gsub(/(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/,'\1,\2')
end

puts "movie title?"
hsx = Hsx.new(gets.chomp)

puts "trading price: $#{hsx.price}"
puts "gross: $#{format_n(hsx.gross)}"
puts "theaters: #{format_n(hsx.theaters)}"