class Calculator
	def divide(x, y)
		x/y 
	end
end
	# => nil
c = Calculator.new
#  => <Calculator>
c.class
	# => Calculator
c.divide(10, 2)

# Note that defining a method inside a class definition adds the method to instances of that class, not to main:
divide(10, 2)
# NoMethodError: undefined method `divide' for main:Object

# One class can bring in another class’s method definitions through inheritance:
class MultiplyingCalculator < Calculator 
	def multiply(x, y)
		x*y 
	end
end

# => nil
mc = MultiplyingCalculator.new 
# => <MultiplyingCalculator>
mc.class
# => MultiplyingCalculator
mc.class.superclass

# A method in a subclass can call a superclass method of the same name by using the super keyword:
class BinaryMultiplyingCalculator < MultiplyingCalculator 
	def multiply(x, y)
		result = super(x, y)
		result.to_s(2) 
	end
end
# => nil

bmc = BinaryMultiplyingCalculator.new 
# => <BinaryMultiplyingCalculator>
bmc.multiply(10, 2)
# => "10100"


# MODULES
module Speak
	def Speak(sound)
		puts sound
	end
end

# CLASSES
class GoodDog
	# include Speak
	def initialize(name)
		@name = name
		# puts "obj init"
	end

	def speak
		"#{@name}  says arf"
	end
end

class Human
	include Speak
end

# instantiation
# sparky = GoodDog.new #=> class instance
sparky = GoodDog.new("Sparky")
sparky.Speak("Arf")
joyce = Human.new
joyce.Speak("Hello")
czar = GoodDog.new
czar.Speak("Bonjour!")

puts sparky.speak #=> sparky says arf

# ACCESSOR METHODS
class GoodDog
	# include Speak
	def initialize(name)
		@name = name
		# puts "obj init"
	end

	#=> A method that returns
	#=> the instance variable
	#=> A getter method
	# ---------------------------
	# def get_name
	# 	@name
	# end

	# def set_name=(name)
	# 	@name = name
	# end
	# ---------- conventionally, -------
	def name
		@name
	end

	def name=(name)
		@name = name
	end
	#-----------------------------------

	def speak
		"#{@name}  says arf"
	end
end

puts sparky.get_name
sparky.set_name = "AppeHaparin"


# USING attr_accessor
class GoodDog
  #=> attr_accessor :name, :height, :weight, :age, :etc
  #=> provides both getter and setter methods
  attr_accessor :name

  #=> Okay cool, but I want only getter methods
  #=> Ruby says no problem
  attr_reader :read

  #=> Okay cool, but I want only setter methods
  #=> Ruby says no problem
  attr_writer :read


  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} says arf!"
  end
end

sparky = GoodDog.new("Sparky")
puts sparky.speak
puts sparky.name            # => "Sparky"
sparky.name = "Spartacus"
puts sparky.name            # => "Spartacus"


#=> GoodDog now
class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    @name = n
    @height = h
    @weight = w
  end

  def speak
    "#{name} says arf!"
  end

  # def change_info(n, h, w)
  #   @name = n
  #   @height = h
  #   @weight = w
  # end

  # Modifying change_info to use setter methods instead of instance variables
  def change_info(n, h, w)
  	# but this is creating new local variables
    # name = n
    # height = h
    # weight = w
    #=> fixed, voila!
    self.name = n
    self.height = h
    self.weight = w
  end

  def info
	  "#{self.name} weighs #{self.weight} and is #{self.height} tall."
	end
end

sparky = GoodDog.new('Sparky', '12 inches', '10 lbs')
puts sparky.info      # => Sparky weighs 10 lbs and is 12 inches tall.

sparky.change_info('Spartacus', '24 inches', '45 lbs')
puts sparky.info      # => Spartacus weighs 45 lbs and is 24 inches tall.


# CLASS METHODS II
def self.what_am_i
	"I am a good dog class"
end

#=> class variables
class GoodDog
	@@num_of_dogs = 0

	def initialize
		@@num_of_dogs += 1
	end

	def self.total_num_of_dogs
		@@num_of_dogs
	end
end

puts GoodDog.total_number_of_dogs   #=> 0

# dog1 = GoodDog.new
# dog2 = GoodDog.new

puts GoodDog.total_number_of_dogs   #=> 2

# Constants
#=> Must begin with a capital letter

# .to_s
#=> implemented by default on all objects
#=> puts calls the obj.to_s. slightly different with arrays
#=> we can create our own instance method to override the default













