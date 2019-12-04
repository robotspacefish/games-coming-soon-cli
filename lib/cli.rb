class CLI
  include Menu

  attr_accessor :mode
  attr_reader :menu_options

  def initialize
    @mode = :platform_select
    @menu_options = {
      platform_select: platform_select_content,
      time_period: time_period_menu_content
    }

    self.print_title
    puts "\nGathering data.... One moment please, this may take a while...\n"

    self.scrape_coming_soon_games
  end

  def scrape_coming_soon_games
    [:pc, :ps4, :xb1, :switch].each do |platform|
      Scraper.scrape_coming_soon_page(platform)
    end
  end
  end

  def choose_menu_to_print
    case self.mode
    when :platform_select
      puts "\n====== Platform Selection Menu ======\n"
      print_menu(self.menu_options[:platform_select], "platform")
    when :time_period
      puts "\n====== Time Period Selection Menu ======\n"
      print_menu(self.menu_options[:time_period], "time period")
    end
  end

  # TODO name this better
  def run_action(selection_sym, selection_str)
    case self.mode
    when :platform_select
      Scraper.scrape_coming_soon_page(selection_sym)
      self.update_mode(:time_period)
    when :time_period
      Game.print_time_period_results(selection_sym,  selection_str)
    end
  end

  def run
    user_input = nil

    loop do
      self.choose_menu_to_print

      quit = menu_options[mode].length
      user_input = gets.strip
      index = user_input.to_i - 1

      if index.between?(0, quit - 1)
        if self.mode == :time_period && index == quit - 1
          puts "\nReturning to Platform Selection Menu\n"
          self.update_mode(:platform_select)
        else
          selection_sym = menu_options[mode].to_a[index][0]
          selection_str = menu_options[mode][selection_sym]

          puts "\nYou selected #{selection_str}.\n"
          self.run_action(selection_sym, selection_str)
        end
      elsif index == quit
        puts "\nThanks for using Games Coming Soon. Goodbye!\n\n"
        exit
      else
        puts "\nYou made an invalid selection.\n"
      end

    end
  end

  def update_mode(new_mode)
    self.mode = new_mode
  end

  def print_title
    puts "\nGames Coming Soon\n"
  end

end