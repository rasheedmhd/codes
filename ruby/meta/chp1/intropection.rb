class Greeting
  def initialize(text)
    @text = text
  end

  def welcome
    @text 
  end
end


my_object = Greeting.new("Hello")