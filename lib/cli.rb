class CLI
  def run
    user_input = nil
    type = nil
    puts "Games Coming Soon"

    until user_input == 'quit' || user_input.to_i.between?(1, 5)
      self.platform_select_menu
      user_input = gets.strip
       exit if user_input == 'quit'

      case user_input.to_i
      when 1
        type = :all
      when 2
        type = :pc
      when 3
        type = :xb1
      when 4
        type = :ps4
      when 5
        type = :switch
      else
        puts "You entered an invalid choice."
      end
    end

    Scraper.scrape_coming_soon_page(type)
  end

  def platform_select_menu
    puts <<-DOC
      1. All
      2. PC
      3. Xbox One
      4. PlayStation 4
      5. Nintendo Switch
     DOC
     print "Enter the number corresponding to the platform you'd like to see upcoming games for, or type 'quit' to quit: "
  end
end