class CLI
  attr_accessor :mode, :user_choices

  def initialize(menus_hash)
    @mode = :platform_select
    menus_hash.each do |menu_key, menu_value|
      MenuOption.new(menu_key, menu_value)
    end

    self.setup_user_choices

    self.print_title
    puts "\nGathering data.... One moment please, this may take a while...\n"

    self.scrape_coming_soon_games
    # self.scrape_all_individual_game_info
  end

  def setup_user_choices
    @user_choices = {
      platform_select: nil,
      time_period_select: nil
    }
  end

  def scrape_individual_game(game)
    Scraper.scrape_game(game) if !game.info_scraped?
  end

  def scrape_coming_soon_games
    [:pc, :ps4, :xb1, :switch].each do |platform|
      Scraper.scrape_coming_soon_page(platform)
    end
  end

  def scrape_all_individual_game_info
    Game.all.each { |game| Scraper.scrape_game(game) }
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
        puts "\nThanks for using Games Coming Soon. Goodbye!\n\n"
        exit

      else
        puts "\nYou made an invalid selection.\n"
      end

    end
  end

  def print_to_cli
    case self.mode
    when :platform_select
      self.print_platform_select

    when :time_period_select
      self.print_time_period_select

    when :game_list
      self.print_game_list
    end
  end

  def update(index)
    case self.mode
    when :platform_select
      self.update_mode(:time_period_select)
    when :time_period_select
      selection = self.find_menu_content.to_a[index][0]
      next_mode = selection == :back_to_platform_select ? :platform_select : :game_list

      self.update_game_list_content
      self.update_mode(next_mode)
    when :game_list
    end
  end

  def print_title
    puts "\nGames Coming Soon\n"
  end

  def print_platform_select
    puts "\n====== Platform Selection Menu ======\n"
    self.find_menu(:platform_select).print_menu
  end

  def print_time_period_select
    puts "\n====== Time Period Selection Menu ======\n"
    self.find_menu(:time_period_select).print_menu
  end

  def print_game_list
    platform = self.user_choices[:platform_select]
    time_period = self.user_choices[:time_period_select]

    puts "\n===== #{platform.upcase} Games Coming Out in #{time_period.to_s.gsub("_", " ").capitalize} =====\n\n"

    game_list = self.find_menu(:game_list).print_menu
  end

  def print_selection_feedback
    selection_str = nil
    if mode == :game_list
      selection_str = self.user_choices[mode].name.upcase
    else
      selection_str = self.user_choices[mode].to_s.upcase.gsub("_", " ")
    end

    puts "\n***** You selected #{selection_str}. *****\n"
  end

  def update_game_list_content
    games = Game.time_period_results(self.user_choices[:platform_select], self.user_choices[:time_period_select])

    self.find_menu(:game_list).menu = games
  end

  def update_user_choice(index)
    self.user_choices[mode] = self.find_menu_content.to_a[index][0]
  end

  def update_mode(new_mode)
    self.mode = new_mode
  end
end