class MainMenu < Menu
  def initialize
    super
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

      if index >= 1 && index < quit
        platform_type = @content.to_a[index][0]
        Scraper.scrape_coming_soon_page(platform_type)
      elsif index == quit
        exit
      else
        puts "You made an invalid selection."
      end
    end
  end
end