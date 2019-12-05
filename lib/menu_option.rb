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
    if self.mode == :game_list
      self.print_game_list_menu
    else
      self.print_from_hash(self.menu)
      self.print_instructions
    end
  end

  def print_game_list_menu
    self.menu.each.with_index(1) do |game, index|
      if index != self.menu.length # quit
        puts "#{index}. #{game.name} - #{game.platform.upcase} - #{game.release_date}"
      end
    end

    quit = self.menu.length

    puts "#{quit}. Quit"
    print "\nEnter the number corresponding to the game you want to see more info about, or enter #{quit} to quit: "
  end
end