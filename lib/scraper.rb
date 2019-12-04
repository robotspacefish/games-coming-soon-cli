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
          release_period: index == 0 ? :seven_days : :fourteen_days,
          platform: type
        })
      end

    end

  end

  def self.scrape_game(game)
    url = "https://www.igdb.com#{game.url}"
    html = open(url)
    doc = Nokogiri::HTML(html)

    game.add_info({
      genres: doc.css("div.gamepage-tabs div:nth-child(2) p:nth-child(1)").text.gsub("Genre:", "").strip.split(", "),
      developers: doc.css("div.optimisly-game-maininfo a.block").text.strip.split(", "),
      summary: doc.css("div.gamepage-tabs div:nth-child(2) div:nth-child(2)").text.gsub("\n", "").gsub("Read More", "").strip
    })
  end
end