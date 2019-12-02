class Game
  attr_accessor :name, :url, :release_date, :release_datetime, :release_period
  @@all = []

  def initialize()
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
end