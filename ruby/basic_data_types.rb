# Everything in Ruby is an object 

### INTEGERS AND FLOATS
17 / 5    #=> 3, not 3.4
17 / 5.0  #=> 3.4

# CONVERTING NUMBER TYPES
# To convert an integer to a float:
13.to_f   #=> 13.0

# To convert a float to an integer:
13.0.to_i #=> 13
13.9.to_i #=> 13 (no rounding)

# NUMBER METHODS
7.even? #=> false
7.odd? #=> true



# STRINGS
"This is my preferred way of writing strings"
'There is this way too'

# String Concatenation
# With the plus operator:
"Welcome " + "to " + "Odin!"    #=> "Welcome to Odin!"
# With the shovel operator:
"Welcome " << "to " << "Odin!"  #=> "Welcome to Odin!"
# With the concat method:
"Welcome ".concat("to ").concat("Odin!")  #=> "Welcome to Odin!"

# Substrings 
"hello"[0]      #=> "h"
"hello"[0..1]   #=> "he"
"hello"[0, 4]   #=> "hell"
"hello"[-1]     #=> "o"

# Escape Characters
\\  #=> Need a backslash in your string?
\b  #=> Backspace
\r  #=> Carriage return, for those of you that love typewriters
\n  #=> Newline. You'll likely use this one the most.
\s  #=> Space
\t  #=> Tab
\""  #=> Double quotation mark
\''  #=> Single quotation mark

# Interpolation
# Only works with ""
name = "Odin"
puts "Hello, #{name}" #=> "Hello, Odin"
puts 'Hello, #{name}' #=> "Hello, #{name}"

# Methods
"starlet".capitalize #=> Starlet
"Maverick".include?("ri") #=> true
"hi".upcase #=> HI
"HELLO".downcase #=> hello
"hi".empty? #=> false
"Star".length
"kcirevam".reverse 
"Starlet Maverick".split #=> ["Starlet", Maverick]
"   hel  lo  ".strip #=> hello
"he77o".sub("7", "l")           #=> "hel7o"
"he77o".gsub("7", "l")          #=> "hello"
"hello".insert(-1, " dude")     #=> "hello dude"
"hello world".delete("l")       #=> "heo word"
"!".prepend("hello, ", "world") #=> "hello, world!"

# Converting other objects to Strings
5.to_s        #=> "5"
nil.to_s      #=> ""
:symbol.to_s  #=> "symbol"



# SYMBOLS
:are_immutable
:store_once_in_memory
:this_is_their_value



# BOOLEANS (true, false, nil)
# Everything in Ruby has a return value
true
false
nil


# Addition
1 + 1   #=> 2

# Subtraction
2 - 1   #=> 1

# Multiplication
2 * 2   #=> 4

# Division
10 / 5  #=> 2

# Exponent
2 ** 2  #=> 4
3 ** 4  #=> 81

# Modulus (find the remainder of division)
8 % 2   #=> 0  (8 / 2 = 4; no remainder)
10 % 4  #=> 2  (10 / 4 = 2 with a remainder of 2)