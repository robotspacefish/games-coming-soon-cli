class Menu
  attr_accessor :instructions, :content, :input

  def print_from_hash
    count = 1
    puts "\n"
    @content.each do |key, value|
      puts "#{count}. #{value}"
      count += 1
    end

    puts "#{count}. Quit"

    print "\n#{@instructions}"
  end

  def print_from_array
    @content.each.with_index(1) do |item, index|
      puts "#{index}. #{item}"
    end

    puts "#{@content.length + 1}. Quit"
  end
end