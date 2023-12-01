require "test_helper"
require "generators/intializer/intializer_generator"

class IntializerGeneratorTest < Rails::Generators::TestCase
  tests IntializerGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
