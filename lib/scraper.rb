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
      section.collect do |media|

      media_body = media.css('div.media-body')
        Game.create({
          name: media_body.css('a').text.strip,
          release_date: media_body.css('time').text.strip,
          release_datetime: media_body.css('time').attribute('datetime').value,
          url: media_body.css('a').attribute('href').value,
          release_period: index == 0 ? :seven_days : :fourteen_days
        })
      end

    end

  end
end

# Scraper.scrape_coming_soon_page(:all)
# Game.all.each do |g|
#   puts "#{g.name}: #{g.release_period}"
# end

