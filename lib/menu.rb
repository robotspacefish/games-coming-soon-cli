module Menu
  def print_from_hash(content)
    count = 1
    puts "\n"
    content.each do |key, value|
      puts "#{count}. #{value}"
      count += 1
    end
  end

  def print_instructions
    print "\nEnter the number corresponding to your selection: "
  end
end