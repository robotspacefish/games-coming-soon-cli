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
end