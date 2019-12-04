class CLI
  include Menu

  attr_accessor :mode, :user_choices
  attr_reader :menu_options

  def initialize
    @mode = :platform_select
    @menu_options = {
      platform_select: platform_select_content,
      time_period_select: time_period_menu_content,
      game_list: nil
    }

    @user_choices = {
      platform_select: nil,
      time_period_select: nil
    }

    self.print_title
    puts "\nGathering data.... One moment please, this may take a while...\n"

    self.scrape_coming_soon_games
    # self.scrape_all_individual_game_info

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

  def print_to_cli
    case self.mode
    when :platform_select
      puts "\n====== Platform Selection Menu ======\n"

      print_menu(self.menu_options[:platform_select])
    when :time_period_select
      puts "\n====== Time Period Selection Menu ======\n"
      print_menu(self.menu_options[:time_period_select])
    when :game_list
      platform = self.user_choices[:platform_select]
      time_period = self.user_choices[:time_period_select]

      puts "\n===== #{platform.upcase} Games Coming Out in #{time_period.to_s.gsub("_", " ").capitalize} =====\n\n"

      Game.print_time_period_results(platform, time_period)
binding.pry
      print_game_list_menu(self.menu_options[:game_list].length)
    end
  end

  def update
    case self.mode
    when :platform_select
      self.update_mode(:time_period_select)
    when :time_period_select
      self.update_mode(:game_list)
      games = Game.time_period_results(self.user_choices[:platform_select], self.user_choices[:time_period_select])
      self.menu_options[:game_list] = self.game_list_content(games)
    when :game_list
    end
  end

  def run
    user_input = nil

    loop do
      self.print_to_cli

      quit = menu_options[mode].length
      user_input = gets.strip
      index = user_input.to_i - 1

      if index.between?(0, quit - 1)
        if self.mode == :time_period_select && index == quit - 1
          puts "\nReturning to Platform Selection Menu\n"
          self.update_mode(:platform_select)
        else
          selection_sym = menu_options[mode].to_a[index][0]
          selection_str = menu_options[mode][selection_sym]

          puts "\nYou selected #{selection_str}.\n"

          self.update_user_choice(selection_sym)
          self.update
        end
      elsif index == quit
        puts "\nThanks for using Games Coming Soon. Goodbye!\n\n"
        exit
      else
        puts "\nYou made an invalid selection.\n"
      end

    end
  end

  def update_user_choice(selection)
    self.user_choices[mode] = selection
  end

  def update_mode(new_mode)
    self.mode = new_mode
  end

  def print_title
    puts "\nGames Coming Soon\n"
  end

end