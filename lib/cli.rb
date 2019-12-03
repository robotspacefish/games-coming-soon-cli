class CLI
  def run
    user_input = nil
    type = nil
    puts "Games Coming Soon"

    MainMenu.new.run

    binding.pry
    # Scraper.scrape_coming_soon_page(platform_type)
  end
end