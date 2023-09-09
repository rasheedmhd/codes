# LOOP
i = 0
loop do
	puts "I is #{i}"
	i += 1
	break if i == 10
end

# WHILE LOOP
a = 0
while a < 10
	puts "a is #{a}"
	i += 1
end

while gets.chomp != "yes" do
  puts "Will you go to prom with me?"
end

# UNTIL LOOP
i = 0
until i >= 10 do
 puts "i is #{i}"
 i += 1
end

until gets.chomp == "yes" do
  puts "Do you like Pizza?"
end

# RANGES
(1..5)      # inclusive range: 1, 2, 3, 4, 5
(1...5)     # exclusive range: 1, 2, 3, 4

# We can make ranges of letters, too!
('a'..'d')  # a, b, c, d


# FOR LOOPS
for i in 0..5
  puts "#{i} zombies incoming!"
end

# TIMES LOOP
5.times do
  puts "Hello, world!"
end

5.times do |number|
  puts "Alternative fact number #{number}"
end

# UPTO and DOWNTO 
#=> inclusive ranges
5.upto(10) { |num| print "#{num} " }     #=> 5 6 7 8 9 10
10.downto(5) { |num| print "#{num} " }   #=> 10 9 8 7 6 5
