require 'test/unit'

# room for refactor
# def to_alphanumeric(s)
#     s.gsub(/[^\w\s]/, '')
# end

# Bill writes
class String
    def to_alphanumeric(s)
        s.gsub(/[^\w\s]/, '')
    end
end

# room for refactor
# class ToAlphaNumeric < Test::Unit::TestCase 

# Bill Writes
class StringExtensionsTest < Test::Unit::TestCase
    def test_strip_non_alphanumeric_chars
        assert_equal '3 the Magic Number', 
        to_alphanumeric('#3, the *Magic, Number*?')
    end
end

7.times do
    class OUT
        puts "Hello"
    end
end

# TODO: Code the Ruby Open Classes idea into a Rust program Using traits
