class Game
  attr_accessor :name, :url, :release_date, :release_datetime, :release_period, :genres, :developers, :summary
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

    self.save(game)
  end

  def self.all
    @@all
  end

  def self.save(game)
    @@all << game
  end

  def add_info(info_hash)
    @genres = info_hash[:genres]
    @developers = info_hash[:developers]
    @summary = info_hash[:summary]
  end

  def self.print_time_period_results(time_period_sym, time_period_str)
    games = nil
    if time_period_sym == :seven_days
      games = self.all.select { |game| game.release_period == time_period_sym }
    else
      games = self.all
    end


    puts "\nGames Coming Out in #{time_period_str}:\n"

    games.each.with_index(1) do |game, index|
      puts "#{index}. #{game.name} - #{game.release_date}"
    end
  end
end