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
  end

  def choose_menu_to_print
    case self.mode
    when :platform_select
      print_menu(self.menu_options[:platform_select], "platform")
    when :time_period
      print_menu(self.menu_options[:time_period], "time period")
    end
  end

  # TODO name this better
  def run_action(selection_sym, selection_str)
    case self.mode
    when :platform_select
      puts "\nOne moment please...\n"
      Scraper.scrape_coming_soon_page(selection_sym)
      self.update_mode(:time_period)
    when :time_period
      Game.print_time_period_results(selection_sym,  selection_str)
    end
  end

  def run
    user_input = nil

    self.print_title

    loop do
      self.choose_menu_to_print

      quit = menu_options[mode].length
      user_input = gets.strip
      index = user_input.to_i - 1

      if index.between?(0, quit - 1)
        selection_sym = menu_options[mode].to_a[index][0]
        selection_str = menu_options[mode][selection_sym]

        puts "\nYou selected #{selection_str}.\n"

        self.run_action(selection_sym, selection_str)
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