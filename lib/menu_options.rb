class MenuOption
  include Menu
  attr_accessor :mode, :menu
  @@all = []

  def initialize(mode, menu)
    @mode = mode
    @menu = menu
    @@all << self
  end

  def self.all
    @@all
  end

  def self.find_menu(mode)
    self.all.find { |menu| menu.mode == mode }
  end

  def print_menu
    self.print_from_hash(self.menu)
    self.print_instructions
  end

  # TODO move this somewhere
  def game_list_content(games)
    list = {}
    games.each do |game|
      game_sym = game.name.to_sym
      list[game_sym] = game
    end
    list[:quit] = "Quit"
    list
  end
end