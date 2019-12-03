class TimePeriodMenu < Menu
  def initialize
    @content = {
      seven_days: "7 Days",
      fourteen_days: "14 Days"
    }
    @instructions = "Enter the number corresponding to the time period you'd like to see upcoming games for, or type #{@content.length + 1} to quit: "
  end
end