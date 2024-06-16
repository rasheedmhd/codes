# Defining methods for Objects
o = Object.new
def o.add(x, y)
	x + y
end

o.add(4, 5)

# Self in Method definition
# Ruby always keeps track of the current object (called self) and will allow us to send a message to that object by writing a message name on its own
def o.add_twice(x, y) 
	add(x, y) + add(x, y) # implicite 'self' awareness
	# self.add(x, y) + self.add(x, y) # verbose

end

o.add_twice(2, 3) => 10

# Any method definitions that don’t specify an object will be made available through main:
def multiply(a, b) 
	a*b
end
# => nil
multiply(2, 3) => 6

# Variadic Methods,
# Methods that takes a variable number or args
def join_with_commas(*words) 
  words.join(', ')
end
# => nil
join_with_commas('one', 'two', 'three') 
# => "one, two, three"

# And finally, * works in parallel assignment too:
before, *words, after = ['Testing: ', 'one', 'two', 'three', '.']
puts before 
puts words 
puts after

# A method definition can’t have more than one variable-length parameter, 
# but normal parameters may appear on either side of it:
def join_with_commas(before, *words, after) 
  before + words.join(', ') + after
end

# => nil
join_with_commas('Testing: ', 'one', 'two', 'three', '.')


# Defining Methods
def my_name
  "Joe Smith"
end

puts my_name    #=> "Joe Smith"

# Rules for naming variables
method_name      # valid
_name_of_method  # valid
# 1_method_name    # invalid
method_27        # valid
method?_name     # invalid
method_name!     # valid
begin            # invalid (Ruby reserved word)
begin_count      # valid

# Parameters and Arguments
def sing(name)
  "Hey, " + name + "!"
end

puts sing("Jude") #=> Hey, Jude!

# Default Parameters
def greet(name = "stranger")
  "Hello, " + name + "!"
end

puts greet("Jane") #=> Hello, Jane!
puts greet #=> Hello, stranger!

# Returning values
def my_name
  "Joe Smith"
end
#=> Ruby has implicits returns
#=> returning the last evaluated expression in the method
puts my_name #=> "Joe Smith"

#=> Explicit return with the "return" keyword
def my_name
  return "Joe Smith"
end

puts my_name #=> "Joe Smith"

def even_odd(number)
  if number % 2 == 0
    "That is an even number."
  else
    "That is an odd number."
  end
end

puts even_odd(16) #=>  That is an even number.
puts even_odd(17) #=>  That is an odd number.

def my_name
  return "Joe Smith"
  # "Jane Doe" # not reachable
end

puts my_name #=> "Joe Smith"

def even_odd(number)
  unless number.is_a? Numeric
    return "A number was not entered."
  end
  if number % 2 == 0
    "That is an even number."
  else
    "That is an odd number."
  end
end

puts even_odd(20) #=>  That is an even number.
puts even_odd("Ruby") #=>  A number was not entered.

# Difference between puts and return
def puts_squared(number)
  puts number * number
end

def return_squared(number)
  number * number
end

x = return_squared(20) #=> 400
y = 100
sum = x + y #=> 500
puts "The sum of #{x} and #{y} is #{sum}."
#=> The sum of 400 and 100 is 500.

# Method chaining
phrase = ["be", "to", "not", "or", "be", "to"]
puts phrase.reverse.join(" ").capitalize
#=> "To be or not to be"

["be", "to", "not", "or", "be", "to"].reverse 
# = ["to", "be", "or", "not", "to", "be"].join(" ")
# = "to be or not to be".capitalize
# = "To be or not to be"

# Predicate Methods
#=> has ? in their names and returns true or false
puts 5.even?  #=> false
puts 6.even?  #=> true
puts 17.odd?  #=> true
puts 12.between?(10, 15)  #=> true

#=> you can create your own predicate methods
#=> with or without the ? at the end, but the
#=> is to have the ? at the end of all predicates methods
#=> helps makes your code more readable and understandable

# BANG METHODS
whisper = "HELLO EVERYBODY"
puts whisper.downcase #=> "hello everybody"
puts whisper #=> "HELLO EVERYBODY"
#=> instead of whisper = whisper.downcase
#=> Ruby gives us whisper.downcase! 
puts whisper.downcase! #=> "hello everybody"
puts whisper #=> "hello everybody"
end

# Blocks
# A block is a piece of Ruby code surrounded by do/end or curly brackets. 
# Methods can take an implicit block argument and call the code in that block with the yield keyword:
def do_three_times_old
  yield
  puts "-----"
  yield
  puts "-----"
  yield
end

do_three_times_old { puts "Hello 3x"}

# Blocks can take arguments:
def do_three_times 
  yield('un')
  yield('deux')
  yield('trois') 
  # yield('first')
  # yield('second')
  # yield('third') 
end
# => nil
do_three_times { |n| puts "#{n}: hello" }
do_three_times { |n| puts "Hello #{n} x" }

# Yield returns the result of executing the block:
# Pretty Neat Huh?
def number_names
  [yield('one'), yield('two'), yield('three')].join(', ')
end

def lang_names
  [ yield('ML'), 
    yield('Rust'), 
    yield('OCaml'), 
    yield('Ruby')
  ].join(', ')
end
# => nil
number_names { |name| name.upcase.reverse }
# => "ENO, OWT, EERHT"