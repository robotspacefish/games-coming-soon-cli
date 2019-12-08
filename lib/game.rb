class Game
  attr_accessor :name, :url, :release_date, :genres, :developers, :publishers, :about, :info_scraped, :platforms, :platform
  @@all = []

  def initialize(platform = nil)
    @info_scraped = false
    @genres = []
    @platforms = []
  end

  def add_platform(platform)
    self.platforms << Platform.find_or_create(platform)
  end

  def self.find_game(game_hash)
    self.all.find do |game|
      game.name == game_hash[:name]
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

  def self.find_by_name(name)
    self.all.find { |g| g.name == name }
  end

  def self.create_or_add_platform(game_hash)
    if self.exists?(game_hash)
      game = self.find_game(game_hash)
      game.add_platform(game_hash[:platform])
    else
      self.create(game_hash)
    end
  end

  def self.exists?(game_to_add)
    self.all.find do |game|
      game.name == game_to_add[:name]
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
    self.genres = info_hash[:genres].empty? ? ["N/A"] : info_hash[:genres]
    self.publishers = info_hash[:publishers].empty? ? ["N/A"] : info_hash[:publishers]
    self.developers = info_hash[:developers].empty? ? ["N/A"] : info_hash[:developers]
    self.about = info_hash[:about].empty? ? "N/A" : info_hash[:about]
  end

  def print_info
    puts " #{self.name} ".center(80, padstr="=").green.on_black
    puts "\n"
    puts "Release Date: #{self.release_date.format_date.green}"
    puts "Developed by #{self.developers.join(", ").green}"
    puts "Published by #{self.publishers.join(", ").green}"
    puts "Genre(s): #{self.genres.join(", ").green}"
    puts "Platform(s): #{self.platforms.collect { |p| p.type.capitalize }.join(", ").green}"
    puts "\nAbout:".bold.underline
    puts self.about.green
  end

  def self.find_games_by_platform_within_month(platform_sym, month)
    platform  = Platform.find_by_type(platform_sym)
    games_in_month = ReleaseDate.find_games_by_month(month)
    games_in_month.select do |game|
      game.platforms.include?(platform)
    end
  end

end