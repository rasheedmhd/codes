my_hash = {
  "a random word" => "ahoy",
  "Dorothy's math test score" => 94,
  "an array" => [1, 2, 3],
  "an empty hash within a hash" => {}
}

# Creating hashes with the .new method
my_hash = Hash.new
my_hash   #=> {}
#=> Hash keys types
hash = { 9 => "nine", :six => 6 }

# Accessing Hash values
shoes = {
  "summer" => "sandals",
  "winter" => "boots"
}
shoes["summer"]   #=> "sandals"


# To prevent null-usage, use-after-free,
#=> use .fetch instead
shoes["hiking"]   #=> nil
shoes.fetch("hiking")   #=> KeyError: key not found: "hiking"
#=> Setting default return values
shoes.fetch("hiking", "hiking boots") #=> "hiking boots"

# Modifying Hashes
shoes["fall"] = "sneakers"
shoes #=> {"summer"=>"sandals", "winter"=>"boots", "fall"=>"sneakers"}
shoes["summer"] = "flip-flops"
shoes #=> {"summer"=>"flip-flops", "winter"=>"boots", "fall"=>"sneakers"}
# with .delete to remove data fro hashes
shoes.delete("summer")  #=> "flip-flops"
shoes #=> {"winter"=>"boots", "fall"=>"sneakers"}

# Methods
#=> .keys
#=> .values
books = {
  "Infinite Jest" => "David Foster Wallace",
  "Into the Wild" => "Jon Krakauer"
}
books.keys      #=> ["Infinite Jest", "Into the Wild"]
books.values    #=> ["David Foster Wallace", "Jon Krakauer"]
#=> .merge(hash_name)
hash1 = { "mb" => 2048, "gb" => 2 }
hash2 = { "tb" => 1024, "pb" => 1 }
hash1.merge(hash2)      #=> { "a" => 100, "b" => 254, "c" => 300 }

# A better way to keys (pronounced as kiss)
# 'Rocket' syntax
american_cars = {
  :chevrolet => "Corvette",
  :ford => "Mustang",
  :dodge => "Ram"
}
# 'Symbols' syntax
japanese_cars = {
  honda: "Accord",
  toyota: "Corolla",
  nissan: "Altima"
}

american_cars[:ford]    #=> "Mustang"
japanese_cars[:honda]   #=> "Accord"


















