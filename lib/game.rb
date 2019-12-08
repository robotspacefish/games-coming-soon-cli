class Game
  attr_accessor :name, :url, :release_date, :genres, :developers, :publishers, :about, :info_scraped, :platforms
  attr_reader :platform
  @@all = []

  def initialize(platform = nil)
    @info_scraped = false
    @genres = []
    @platforms = []
  end

  def platform=(platform)
    @platform = platform
    platform.games << self if !platform.games.include?(self)
  end

  def add_platform(platform)
    self.platforms << Platform.find_or_create(platform)
  end

  def self.find_game(game_hash)
    self.all.find do |game|
      game.name == game_hash[:name] && game.release_date.date == game_hash[:release_date]
    end
  end

  def self.create(game_hash)
    game = self.new
    game.name = game_hash[:name]
    game.url = game_hash[:url]
    game.release_date = ReleaseDate.find_or_create(game_hash[:release_date])
    game.platform = Platform.find_or_create(game_hash[:platform])
    game.platforms << game.platform
    self.save(game)
  end

  def self.create_or_add_platform(game_hash)

    if self.exists?(game_hash)
      game = self.find_game(game_hash)
      game.add_platform(game_hash[:platform])
      # puts "adding platform #{game_hash[:platform]} to #{game_hash[:name]}".red
      stored_game = Game.find_game(game_hash)
      stored_game_platforms = stored_game.platforms.collect { |p| p.type }
      # puts "#{stored_game.name} platforms: #{stored_game_platforms.join(", ")}".yellow
    else
      # puts "creating #{game_hash[:name]} for #{game_hash[:platform]}".green
      self.create(game_hash)
    end
  end

  def self.exists?(game_to_add)
    self.all.find do |game|
      game.name == game_to_add[:name] && game.release_date == game_to_add[:release_date]
    end
  end

  def self.all
    @@all
  end

  def self.all_of_platform_type(platform_sym)
    Platform.find_by_type(platform_sym).games
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

  def print_info
    puts "#{' '.rjust(20, '=')} #{self.name} #{' '.ljust(20, '=')}".green.on_black
    puts "\n"
    puts "Developed by #{self.developers.green}"
    puts "Published by #{self.publishers.green}"
    puts "Genre(s): #{self.genres.join(", ").green}"
    puts "\nAbout:".bold.underline
    puts self.about.green
  end

  def self.find_games_by_platform_within_month(platform, month)
    games = Platform.find_all_by_type(platform)
    games = games.ReleaseDate.find_all_by_month(month)
    games
  end

  def self.find_months_by_platform(platform)

  end
end