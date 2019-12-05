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

  def print_instructions
    print "\nEnter the number corresponding to your selection: "
  end
end