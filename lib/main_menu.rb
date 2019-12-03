class MainMenu < Menu
  def initialize
    super
    @content = {
      all:  "All",
        pc: "PC (Windows)",
        xb1: "Xbox One",
        ps4: "PlayStation 4",
        switch: "Nintendo Switch"
      }

      @instructions = "Enter the number corresponding to the platform you'd like to see upcoming games for, or type #{@content.length + 1} to quit: "
  end
end