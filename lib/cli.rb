class CLI
  include Menu
  def run
    user_input = nil
    type = nil
    puts "Games Coming Soon"

    MainMenu.new.run
    TimePeriodMenu.new.run

  end
end