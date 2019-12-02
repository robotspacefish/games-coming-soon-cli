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

    content = doc.css('div.content div.pad div.row')
    sections = [content.css('div:nth-child(1) div.media'), content.css('div:nth-child(2) div.media')]

    sections.collect.with_index(0) do |section, index|
      upcoming_games = {}
      section.collect do |media|
      media_body = media.css('div.media-body')
      game_symbol = media_body.css('a').text.gsub(/\W+/, "").to_sym
      upcoming_games[game_symbol] = {
      name: media_body.css('a').text.strip,
      date: media_body.css('time').text.strip,
      datetime: media_body.css('time').attribute('datetime').value,
      url: media_body.css('a').attribute('href').value
      }
      end
      upcoming_games
    end
  end
end

test_games = Scraper.scrape_coming_soon_page(:pc)