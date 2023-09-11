# Debugging with puts/p
def isogram?(string)
  original_length = string.length
  string_array = string.downcase.split
  unique_length = string_array.uniq.length
  original_length == unique_length
end

isogram?("Odin") #=> false

# fixing the bug with .splt("")
# Debugging with puts/p
def isogram?(string)
  original_length = string.length
  string_array = string.downcase.split("")
  unique_length = string_array.uniq.length
  original_length == unique_length
end

isogram?("Odin") #=> false

puts "Using puts:"
puts [] #=> 
p "Using p:"
p [] #=> []

# DEBUGGING WITH PRY-BYEBUG
require 'pry-byebug'

def isogram?(string)
  original_length = string.length
  string_array = string.downcase.split

  binding.pry

  unique_length = string_array.uniq.length
  original_length == unique_length
end

isogram?("Odin")


