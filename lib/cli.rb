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
    case mode
    when :platform_select
      print_menu(menu_options[:platform_select], "platform")
    when :time_period
      print_menu(menu_options[:time_period], "time period")
    end
  end

  def run
    user_input = nil

    print_title

    loop do
      choose_menu_to_print

      quit = menu_options[mode].length
      user_input = gets.strip
      index = user_input.to_i - 1

      if index.between?(0, quit - 1)
        selection_sym = menu_options[mode].to_a[index][0]
        selection_str = menu_options[mode][selection_sym]

        puts "\nYou selected #{selection_str}.\n"

        # case mode
        # when :platform_select

        # when :time_period
        # end
      elsif index == quit
        puts "\nThanks for using Games Coming Soon. Goodbye!\n\n"
        exit
      else
        puts "\nYou made an invalid selection.\n"
      end




    end
  end

  def print_title
    puts "\nGames Coming Soon\n"
  end

end