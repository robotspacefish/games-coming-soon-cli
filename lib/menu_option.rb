class MenuOption
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
        output = index < 10 ? "0" : ""
        output += "#{index}. #{game.name.ljust(50, '.')}#{game.platform.to_s.upcase.ljust(20, '.')}#{game.release_date.rjust(17, '.')}"

        puts index.even? ? output.yellow.on_black : output.black.on_yellow
        # puts index.even? ? output.white.on_black : output.black.on_white

      end
    end

    quit = self.menu.length

    puts "#{quit}. Quit".red.bold
    print "\nEnter the number corresponding to the game you want to see more info about, or enter #{quit} to quit: "
  end

  def print_from_hash(content)
    count = 1
    puts "\n"
    content.each do |key, value|
      puts "#{count}. #{value}"
      count += 1
    end

    puts "#{count}. Quit".red.bold
  end

  def print_instructions
    print "\nEnter the number corresponding to your selection: "
  end
end