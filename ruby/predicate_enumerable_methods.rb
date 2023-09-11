numbers = [5, 6, 7, 8]
element = 6
result = false

numbers.each do |number|
  if number == element
    result = true
  end
end

result
# => true

element = 3
result = false

numbers.each do |number|
  if number == element
    result = true
  end
end

result
#=> false

# The .include? method
numbers.include?(6) #=> true
numbers.include?(3) #=> false

friends = ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']
invited_list = friends.select { |friend| friend != 'Brian' }
invited_list.include?('Brian')  #=> false

numbers = [21, 42, 303, 499, 550, 811]
result = false
numbers.each do |number|
  if number > 500
    result = true
  end
end
result  #=> true

numbers = [21, 42, 303, 499, 550, 811]
result = false
numbers.each do |number|
  if number < 20
    result = true
  end
end
result  #=> false

# The .any? method
numbers = [21, 42, 303, 499, 550, 811]
numbers.any? { |number| number > 500 }  #=> true
numbers.any? { |number| number < 20 } #=> false

# The .all? method
fruits = ["apple", "banana", "strawberry", "pineapple"]
matches = []
result = false
fruits.each do |fruit|
  if fruit.length > 3
    matches.push(fruit)
  end
  result = fruits.length == matches.length
end
result  #=> true

fruits = ["apple", "banana", "strawberry", "pineapple"]
matches = []
result = false
fruits.each do |fruit|
  if fruit.length > 6
    matches.push(fruit)
  end
  result = fruits.length == matches.length
end
result #=> false

#=> Using #all?,
fruits = ["apple", "banana", "strawberry", "pineapple"]
fruits.all? { |fruit| fruit.length > 3 }  #=> true
fruits.all? { |fruit| fruit.length > 6 }  #=> false

# The .none? method
fruits = ["apple", "banana", "strawberry", "pineapple"]
fruits.none? { |fruit| fruit.length > 10 }  #=> true
fruits.none? { |fruit| fruit.length > 6 } #=> false























