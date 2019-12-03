class MainMenu < Menu
  def initialize
    @content = {
      all:  "All",
        pc: "PC (Windows)",
        xb1: "Xbox One",
        ps4: "PlayStation 4",
        switch: "Nintendo Switch"
      }

      @instructions = "Enter the number corresponding to the platform you'd like to see upcoming games for, or type #{@content.length + 1} to quit: "
  end

  def run
    quit = @content.length

    until @input.to_i.between?(1, quit)
      self.print_from_hash

      @input = gets.strip
      index = @input.to_i - 1

      if index.between?(0, quit - 1)
        platform_type = @content.to_a[index][0]

        puts "\nYou selected #{content[platform_type]}.\n"

        Scraper.scrape_coming_soon_page(platform_type)
      elsif index == quit
        puts "\nThanks for using Games Coming Soon. Goodbye!\n"
        exit
      else
        puts "\nYou made an invalid selection.\n"
      end
    end
  end
end