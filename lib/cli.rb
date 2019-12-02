class CLI
  def run
    user_input = nil
    puts "Games Coming Soon"

    until user_input == 'quit'
      puts <<-DOC
      1. All
      2. PC
      3. Xbox One
      4. PlayStation 4
      5. Nintendo Switch

      Enter the number corresponding to the platform you'd like to see upcoming games for, or type 'quit' to quit:
     DOC

     user_input = gets.strip
    end
  end
end