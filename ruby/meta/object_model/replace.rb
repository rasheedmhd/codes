def replace(array, original, replacement) 
    array.map {|e| e == original ? replacement : e }
end