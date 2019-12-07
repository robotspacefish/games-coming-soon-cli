class Platform
  attr_accessor :type, :games
  @@all = []

  def initialize(type)
    @type = type
    @games = []
  end

  def self.all
    @@all
  end

  def self.create(type)
   platform = self.new(type)
   platform.save
   platform
  end

  def self.find_by_type(type)
    self.all.find { |platform| platform.type == type }
  end

  def self.find_or_create(type)
    platform = self.find_by_type(type)
    platform ? platform : self.create(type)
  end

  def save
    self.class.all << self
  end


end