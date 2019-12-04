module Menu
  def print_from_hash(content)
    count = 1
    puts "\n"
    content.each do |key, value|
      puts "#{count}. #{value}"
      count += 1
    end
  end

  def print_menu(content = nil)
    if content
      print_from_hash(content)
    end
    print_instructions
  end

  def print_game_list_menu(list_length)
    quit = list_length
    puts "#{quit}. Quit"
    print "\nEnter the number corresponding to the game you want to see more info about, or enter #{quit} to quit: "
  end

  def platform_select_content
    {
      all:  "All",
      pc: "PC (Windows)",
      xb1: "Xbox One",
      ps4: "PlayStation 4",
      switch: "Nintendo Switch",
      quit: "Quit"
    }
  end

  def time_period_menu_content
    {
      seven_days: "7 Days",
      fourteen_days: "14 Days",
      back_to_platform_select: "Back to Platform Selection",
      quit: "Quit"
    }
  end

  def game_list_content(games)
    list = {}
    games.each do |game|
      game_sym = game.name.to_sym
      list[game_sym] = game
    end
    list[:quit] = "Quit"
    list
  end

  def print_instructions
    print "\nEnter the number corresponding to your selection: "
  end

  # def print_from_array
  #   @content.each.with_index(1) do |item, index|
  #     puts "#{index}. #{item}"
  #   end

  #   puts "#{@content.length + 1}. Quit"

  #   print "\n#{@instructions}"
  # end
end