class ReleaseDate
  attr_accessor :day, :month, :year, :date

  @@all = []
  @@month_words = [nil, "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]

  def initialize(release_date)
    @date = release_date
    d = DateTime.strptime(release_date, '%Y-%m-%d')
    @day = d.day
    @month = d.month
    @year = d.year
  end

  def self.month_words
    @@month_words
  end

  def games
    Game.all.select { |game| game.release_date == self }
  end

  def print_date
    puts "#{self.month}/#{self.day}/#{self.year}"
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  def self.find_by_release_date(release_date)
    self.all.find {|r| r.date == release_date }
  end

  def self.create(release_date)
    r = self.new(release_date)
    r.save
    r
  end

  def self.find_or_create(release_date)
    r = self.find_by_release_date(release_date)
    r ? r : self.create(release_date)
  end

  def self.find_all_by_date(date)
    self.all.select { |r| r.date == date }
  end

  def self.find_all_by_month(month)
    self.all.select { |r| r.month == month }
  end

  def self.find_games_by_month(month)
    Game.all.select do |game|
      game.release_date.month == self.month_words.index { |word| word == month }
    end
  end

  def self.find_all_by_day(day)
    self.all.select { |r| r.day == day }
  end

  def self.find_all_by_year(year)
    self.all.select { |r| r.year == year }
  end

  def self.find_all_by_month_and_year(month, year)
    self.all.select { |r| r.month == month && r.year == year }
  end

  def self.find_all_unique_dates
    self.all.collect { |r| r.date }.uniq
  end

  def self.find_all_unique_months
   self.all.collect { |r| r.month }.uniq
  end
end