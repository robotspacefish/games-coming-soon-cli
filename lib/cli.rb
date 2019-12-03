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

  def run
    user_input = nil
    type = nil
    puts "Games Coming Soon"

    MainMenu.new.run
    TimePeriodMenu.new.run

  end
end