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

  def print_menu(platform = nil)
    if self.mode == :game_list
      platform == :all ? self.print_game_list_menu(:all) : self.print_game_list_menu
    elsif self.mode == :month_select
      self.print_from_array(self.menu)
      self.print_instructions
    else
      self.print_from_hash(self.menu)
      self.print_instructions
    end
  end

  def print_game_list_menu(platform = nil)
    self.menu.each.with_index(1) do |game, index|
        output = index < 10 ? "0" : ""
        if platform == :all
          output += "#{index}. #{game.name.ljust(60)}#{game.release_date.date.rjust(20)}   #{game.platforms.collect{ |p| p.type.upcase }.join("|").ljust(20)}"
        else
          output += "#{index}. #{game.name.ljust(60)}#{game.release_date.date.rjust(20)}"
        end
          puts index.even? ? output.green.on_black : output.black.on_green
    end

    quit = self.menu.length + 1

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

  def print_from_array(content)
    puts "\n"
    content.each.with_index(1) do |item, index|
      puts "#{index}. #{item}"
    end
    puts "#{content.length + 1}. Quit".red.bold
  end

  def print_instructions
    print "\nEnter the number corresponding to your selection: "
  end
end