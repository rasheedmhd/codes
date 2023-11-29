class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  attr_accessor :name
  def initialize(n)
    self.name = n
  end
  def speak()
    "say name: #{self.name}"
end

class Cat < Animal
end

sparky = GoodDog.new
paws = Cat.new
puts sparky.speak
puts paws.speak

# super
class Animal
  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  def speak
    super + " from GoodDog class"
  end
end

sparky = GoodDog.new
sparky.speak        # => "Hello! from GoodDog class"


# Mixing Modules
module Swimmable
  def swim
    "I'm swimming!"
  end
end

class Animal; end

class Fish < Animal
  include Swimmable         # mixing in Swimmable module
end

class Mammal < Animal
end

class Cat < Mammal
end

class Dog < Mammal
  include Swimmable         # mixing in Swimmable module
end





