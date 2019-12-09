class CLI
  attr_accessor :mode, :user_choices
  LINE_WIDTH = 80
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
        self.update_month_select_content
        self.update_mode(:month_select)

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
        next_mode = self.find_menu_content.to_a[index][0]
        self.update_mode(next_mode)
    end
  end

  def print_title
    puts "\n"
    puts "+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+".center(LINE_WIDTH)
    puts "|G|a|m|e|s| |C|o|m|i|n|g| |S|o|o|n|".center(LINE_WIDTH).red
    puts "+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+".center(LINE_WIDTH)
    puts "\n"
  end

  def print_platform_select
    puts "\n"
    puts " Platform Selection Menu ".center(LINE_WIDTH, padstr="=").black.bold.on_white
    puts "\n"
    self.find_menu(:platform_select).print_menu
  end

  def print_month_select
    puts "\n"
    puts " Upcoming Month Selection Menu ".center(LINE_WIDTH, padstr="=").black.bold.on_white
    puts "\n"
    self.find_menu(:month_select).print_menu
  end

  def print_individual_game_select
    puts "\n"
    puts " Menu ".center(LINE_WIDTH, padstr="=").black.bold.on_white
    puts "\n"
    self.find_menu(:individual_game).print_menu
  end

  def print_game_list
    platform = self.user_choices[:platform_select]
    month = self.user_choices[:month_select]

    puts " #{platform.to_s.upcase} Games Coming Out in #{month.capitalize} ".center(LINE_WIDTH, padstr="=").black.bold.on_white
    puts "\n"

    game_list = self.find_menu(:game_list)

    platform == :all ? game_list.print_menu(:all) : game_list.print_menu
  end

  def print_selection_feedback
    selection_str = nil
    if mode == :game_list
      selection_str = self.user_choices[mode].name.upcase
    elsif mode == :month_select
      selection_str = self.user_choices[mode].upcase
    else
      selection_str = self.user_choices[mode].to_s.upcase.gsub("_", " ")
    end

    puts "\n"
    puts "You selected #{selection_str}".green
    puts "\n"
  end

  def update_game_list_content
    month = self.user_choices[:month_select]
    platform_sym = self.user_choices[:platform_select]
    games = nil

    if platform_sym == :all
      games = ReleaseDate.find_games_by_month(month)
      ReleaseDate.sort_by_datetime(games)
    else
      games = Game.find_games_by_platform_within_month(platform_sym, month)
    end

    self.create_game_list_menu(games)
  end

  def create_game_list_menu(games)
    find_menu(:game_list).menu = games
  end

  def update_month_select_content
    platform = self.user_choices[:platform_select]
    dates = nil

    if platform == :all
      dates = Game.unique_months
    else
      dates = Platform.find_by_type(platform).unique_months
    end


    menu = self.find_menu(:month_select)
    menu.menu = dates.collect { |month| ReleaseDate.month_words[month] }
    menu.menu << "Back to Platform Selection"
  end

  def update_user_choice(index)
    choice = nil
    if mode == :game_list || mode == :month_select
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