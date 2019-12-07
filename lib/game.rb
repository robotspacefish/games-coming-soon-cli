class Game
  attr_accessor :name, :url, :release_date, :release_datetime, :release_period, :platform, :genres, :developers, :publishers, :about, :info_scraped
  @@all = []

  def initialize()
    @info_scraped = false
    @genres = []
  end

  def self.create(games_hash)
    game = self.new
    game.name = games_hash[:name]
    game.url = games_hash[:url]
    game.release_date = games_hash[:release_date]
    game.release_datetime = games_hash[:release_datetime]
    game.release_period = games_hash[:release_period]
    game.platform = games_hash[:platform]

    self.save(game) if !self.exists?(game)
  end

  def self.exists?(game_to_add)
    self.all.detect do |game|
      game.name == game_to_add.name && game.platform == game_to_add.platform
    end
  end

  def self.all
    @@all
  end

  def self.all_of_platform_type(platform_sym)
    self.all.select { |game| game.platform == platform_sym }
  end

  def self.print_all
    self.all.each.with_index(1) do |game, index|
      puts "#{index}. #{game.name} - #{game.platform.upcase} - #{game.release_date}"
    end
  end

  def self.save(game)
    @@all << game
  end

  def add_info(info_hash)
    self.genres = info_hash[:genres].empty? ? "N/A" : info_hash[:genres]
    self.publishers = info_hash[:publishers].empty? ? "N/A" : info_hash[:publishers]
    self.developers = info_hash[:developers].empty? ? "N/A" : info_hash[:developers]
    self.about = info_hash[:about].empty? ? "N/A" : info_hash[:about]
  end

  def self.time_period_results(platform_sym, time_period_sym)
    # note: all games of platform type print for 14 day time period
    games = nil
    if platform_sym == :all
      games = self.all
    else
      games = all_of_platform_type(platform_sym)
    end

    if time_period_sym == :seven_days
      games = games.select { |game| game.release_period == time_period_sym }
    end

    games
  end

  def print_info
    puts "#{' '.rjust(20, '=')} #{self.name} #{' '.ljust(20, '=')}".green.on_black
    puts "\n"
    puts "Developed by #{self.developers.green}"
    puts "Published by #{self.publishers.green}"
    puts "Genre(s): #{self.genres.join(", ").green}"
    puts "\nAbout:".bold.underline
    puts self.about.green
  end
end