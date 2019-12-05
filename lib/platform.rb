class Platform
  attr_accessor :type
  attr_reader :platforms

  def initialize(type)
    @type = type
    @platforms = []
  end

end