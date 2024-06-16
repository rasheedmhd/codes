if today == true
	"Learn Ruby"
end

puts "true" if 2 > 1

if attack_by_land == true
  puts "release the goat"
else
  puts "release the shark"
end

if attack_by_land == true
  puts "release the goat"
elsif attack_by_sea == true
  puts "release the shark"
else
  puts "release Kevin the octopus"
end


# BOOLEAN LOGIC
5 == 5 #=> true
5 == 6 #=> false

5 != 7 #=> true
5 != 5 #=> false

7 > 5 #=> true
5 > 7 #=> false

5 < 7 #=> true
7 < 5 #=> false

7 >= 7 #=> true
7 >= 5 #=> true

5 <= 5 #=> true
5 <= 7 #=> true

5.eql?(5.0) #=> false; although they are the same value, one is an integer and the other is a float
5.eql?(5)   #=> true

a = 5
b = 5
a.equal?(b) #=> true

a = "hello"
b = "hello"
a.equal?(b) #=> false

5 <=> 10    #=> -1
10 <=> 10   #=> 0
10 <=> 5    #=> 1

# Logical Operators
if 1 < 2 && 5 < 6
  puts "Party at Kevin's!"
end

# This can also be written as
if 1 < 2 and 5 < 6
  puts "Party at Kevin's!"
end

if 10 < 2 || 5 < 6 #=> although the left expression is false, there is a party at Kevin's because the right expression returns true
  puts "Party at Kevin's!"
end

# This can also be written as
if 10 < 2 or 5 < 6
  puts "Party at Kevin's!"
end

if !false     #=> true
if !(10 < 5)  #=> true

# CASE STATEMENTS
grade = 'F'

#=> create a variable `did_i_pass` and assign 
#=> the result of a call to case with the variable grade passed in
did_i_pass = case grade 
  when 'A' then "Hell yeah!"
  when 'D' then "Don't tell your mother."
  else "'YOU SHALL NOT PASS!' -Gandalf" #=> default case when none matches
end

#=> more verbose eg when you want to write more complex code
type = 'A'
case type
when 'A'
  puts "You're a genius"
  future_bank_account_balance = 5_000_000
when 'D'
  puts "Better luck next time"
  can_i_retire_soon = false
else
  puts "'YOU SHALL NOT PASS!' -Gandalf"
  fml = true
end



# UNLESS
#=> opposite of if
age = 19
unless age < 18
  puts "Get a job."
end

#=> Just like with if statements, you can write a simple unless 
#=> statement on one line, and you can also add an else clause.

age = 19
puts "Welcome to a life of debt." unless age < 18

unless age < 18
  puts "Down with that sort of thing."
else
  puts "Careful now!"
end


# TERNARY
age = 19
response = age < 18 ? "You still have your entire life ahead of you." : "You're all grown up." end
puts response #=> "You're all grown up." 
end