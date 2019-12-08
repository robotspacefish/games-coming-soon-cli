class CLI
  attr_accessor :mode, :user_choices

  def initialize(menus_hash)
    @mode = :platform_select
    menus_hash.each do |menu_key, menu_value|
      MenuOption.new(menu_key, menu_value)
    end
    self.setup_user_choices

    self.print_title
    puts "Gathering data.... One moment please, this may take a while...".yellow

    self.scrape_coming_soon_games
  end

  def setup_user_choices
    @user_choices = {
      platform_select: nil,
      # time_period_select: nil,
      month_select: nil,
      start_over_select: nil
    }
  end

  def scrape_individual_game(game)
    Scraper.scrape_game_info_page(game) if !game.info_scraped
  end

  def scrape_coming_soon_games
    [:pc, :ps4, :xb1, :switch].each do |platform|
      Scraper.scrape_coming_soon_page(platform)
    end
  end

  def scrape_all_individual_game_info
    Game.all.each { |game| Scraper.scrape_game_info_page(game) }
  end

  def find_menu(mode = self.mode)
    MenuOption.find_menu(mode)
  end

  def find_menu_content(mode = self.mode)
    find_menu(mode).menu
  end

  def run
    user_input = nil

    loop do
      self.print_to_cli
      quit = self.find_menu_content.length
      user_input = gets.strip
      index = user_input.to_i - 1

      if index.between?(0, quit - 1)
        self.update_user_choice(index)
        self.print_selection_feedback
        self.update(index)

      elsif index == quit
        puts "\nThanks for using Games Coming Soon. Goodbye!".green
        exit

      else
        puts "\nYou made an invalid selection.".red
      end

    end
  end

  def print_to_cli
    case self.mode
      when :platform_select
        self.print_platform_select

      # when :time_period_select
      #   self.print_time_period_select

       when :month_select
        self.print_month_select

      when :game_list
        self.print_game_list

      when :individual_game
        self.user_choices[:game_list].print_info
        self.print_individual_game_select
    end
  end

  def update(index)
    case self.mode
      when :platform_select
        # self.update_mode(:time_period_select)
        self.update_month_select_content
        self.update_mode(:month_select)
      # when :time_period_select
      #   selection = self.find_menu_content.to_a[index][0]
      #   next_mode = selection == :back_to_platform_select ? :platform_select : :game_list

      #   self.update_game_list_content
      #   self.update_mode(next_mode)

      when :month_select
        selection = self.find_menu_content[index]
        next_mode = selection == "Back to Platform Selection" ? :platform_select : :game_list

        self.update_game_list_content
        self.update_mode(next_mode)

      when :game_list
        game = self.user_choices[:game_list]

        if !game.info_scraped
          puts "\nGathering information...".yellow
          puts "\n\n"
          scrape_individual_game(game)
        end

        self.update_mode(:individual_game)

      when :individual_game

    end
  end

  def print_title
    puts "\n"
    puts "+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+"
    puts "|G|a|m|e|s| |C|o|m|i|n|g| |S|o|o|n|".red
    puts "+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+"
    puts "\n"
  end

  def print_platform_select
    puts "\n"
    puts "#{' '.rjust(40, '=')} #{"Platform Selection Menu"} #{' '.ljust(40, '=')}".black.bold.on_white
    self.find_menu(:platform_select).print_menu
  end

  # def print_time_period_select
  #   puts "\n"
  #   puts "#{' '.rjust(40, '=')} #{"Time Period Selection Menu"} #{' '.ljust(40, '=')}".black.bold.on_white
  #   self.find_menu(:time_period_select).print_menu
  # end

    def print_month_select
    puts "\n"
    puts "#{' '.rjust(40, '=')} #{"Upcoming Month Selection Menu"} #{' '.ljust(40, '=')}".black.bold.on_white
    self.find_menu(:month_select).print_menu
  end

  def print_individual_game_select
    puts "\n"
    puts "#{' '.rjust(40, '=')} #{"Menu"} #{' '.ljust(40, '=')}".black.bold.on_white
    self.find_menu(:individual_game).print_menu
  end

  def print_game_list
    platform = self.user_choices[:platform_select]
    # time_period = self.user_choices[:time_period_select]

    month = self.user_choices[:month_select]
    # puts "#{' '.rjust(20, '=')} #{platform.upcase} Games Coming Out in #{time_period.to_s.gsub("_", " ").capitalize} #{' '.ljust(20, '=')}".black.bold.on_white
    puts "#{' '.rjust(20, '=')} #{platform.upcase} Games Coming Out in #{month.capitalize} #{' '.ljust(20, '=')}".black.bold.on_white
    # puts "\n===== #{platform.upcase} Games Coming Out in #{time_period.to_s.gsub("_", " ").capitalize} =====".black.bold.on_white
    puts "\n"

    game_list = self.find_menu(:game_list).print_menu
  end

  def print_selection_feedback
    selection_str = nil
    if mode == :game_list
      selection_str = self.user_choices[mode].name.upcase
    else
      selection_str = self.user_choices[mode].to_s.upcase.gsub("_", " ")
    end

    puts "\n"
    puts "You selected #{selection_str}".green
    puts "\n"
  end

  def update_game_list_content
    games = Game.time_period_results(self.user_choices[:platform_select], self.user_choices[:time_period_select])

    self.find_menu(:game_list).menu = games
  end

  def update_month_select_content
    platform = self.user_choices[:platform_select]
    dates = Platform.find_by_type(platform).unique_months
    menu = self.find_menu(:month_select)
    menu.menu = dates.collect { |month| ReleaseDate.month_words[month] }
    menu.menu << "Back to Platform Selection"
  end

  def update_user_choice(index)
    choice = nil
    if mode == :game_list
      choice = self.find_menu_content[index]
    else
      choice = self.find_menu_content.to_a[index][0]
    end

    self.user_choices[mode] = choice
  end

  def update_mode(new_mode)
    self.mode = new_mode
  end
end