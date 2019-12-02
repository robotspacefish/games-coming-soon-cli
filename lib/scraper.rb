class Scraper
  def self.scrape_coming_soon_page(type)
    url = 'https://www.igdb.com/games/coming_soon'
    case type
    when :pc
      url += '?pfilter=6'
    when :ps4
      url += '?pfilter=48'
    when :xb1
      url += '?pfilter=49'
    when :switch
      url += '?pfilter=130'
    when :all
    else
      puts "Invalid type. Here are the results for all platforms"
    end

    html = open(url)
    doc = Nokogiri::HTML(html)
    binding.pry
end

Scraper.scrape_coming_soon_page(:pc)