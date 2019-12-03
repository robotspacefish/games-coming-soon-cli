class TimePeriodMenu < Menu
  def initialize
    @content = {
      seven_days: "7 Days",
      fourteen_days: "14 Days"
    }
    @instructions = "Enter the number corresponding to the time period you'd like to see upcoming games for, or type #{@content.length + 1} to quit: "
  end

  def run
    quit = @content.length

    until @input.to_i.between?(1, quit)
      self.print_from_hash

      @input = gets.strip
      index = @input.to_i - 1

      if index.between?(0, quit - 1)
        time_period = @content.to_a[index][0]

        puts "\nYou selected #{@content[time_period]}.\n"

        Game.print_time_period_results(time_period)
      elsif index == quit
        puts "\nThanks for using Games Coming Soon. Goodbye!\n"
        exit
      else
        puts "\nYou made an invalid selection.\n"
      end
    end
  end
end