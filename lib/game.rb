class Game
  attr_accessor :name, :url, :release_date, :release_datetime, :release_period,  :platform, :genres, :developers, :summary
  @@all = []

  def initialize()
    @genres = []
    @developers = []
  end

  def self.create(games_hash)
    game = self.new
    game.name = games_hash[:name]
    game.url = games_hash[:url]
    game.release_date = games_hash[:release_date]
    game.release_datetime = games_hash[:release_datetime]
    game.release_period = games_hash[:release_period]
    game.platform = games_hash[:platform]
    self.save(game)
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
    @genres = info_hash[:genres]
    @developers = info_hash[:developers]
    @summary = info_hash[:summary]
  end

  def self.print_time_period_results(platform, time_period_sym, time_period_str)
     # note: all games of platform type print for 14 day time period
    games = all_of_platform_type(platform)
    if time_period_sym == :seven_days
      games = games.select { |game| game.release_period == time_period_sym }
    end

    puts "\n#{platform.upcase} Games Coming Out in #{time_period_str}:\n\n"

    games.each.with_index(1) do |game, index|
      puts "#{index}. #{game.name} - #{game.release_date}"
    end
  end
end