require "minitest/autorun"
require "gemtrick"

class GemtrickTest < Minitest::Test

  def greet
    assert_equal "hola mundo!",
      Gemtrick.greet
  end
end