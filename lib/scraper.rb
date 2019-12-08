class Scraper
  def self.scrape_coming_soon_page(type)
    html = open(self.setup_main_url(type))
    doc = Nokogiri::HTML(html)

    scrape_games(doc, type)
    scrape_next_pages_for_type(doc, type)
  end

  def self.scrape_next_pages_for_type(doc, type)
    additional_platform_links = doc.css('ul.pagination').css('li a').collect do |link|
      link.attribute("href").value
    end
    additional_platform_links.pop # remove 'Next' page link

    additional_platform_links.each do |link|
      base_url = 'https://www.igdb.com'
      html = open(base_url + link)

      scrape_games(Nokogiri::HTML(html), type)
    end
  end

  def self.scrape_games(doc, type)
    doc.css('tr').collect do |game|
      create_game_from_scrape(game, type)
    end
  end

  def self.create_game_from_scrape(game, type)
    Game.create_or_add_platform({
      name: game.css('td')[1].text,
      release_date: game.css('time').text,
      release_datetime: game.css('time').attribute('datetime').value,
      url: game.css('a').attribute('href').value,
      platform: type
    })
  end

  def self.setup_main_url(type)
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
    end

    url
  end

  def self.scrape_game_info_page(game)
    doc = Nokogiri::HTML(open("https://www.igdb.com#{game.url}"))

    game.add_info({
      publishers: doc.xpath("//span[@itemprop='publisher']").text,
      developers: doc.xpath("//div[@itemprop='author']").text,
      genres: doc.xpath("//a[@itemprop='genre']").collect { |g| g.text },
      about: doc.css("div.gamepage-tabs > div:nth-child(2) > div:first-of-type").text.gsub("Read More", "").strip,
      info_scraped: true
    })
  end
end