require "test_helper"
require "generators/shrine/shrine_generator"

class ShrineGeneratorTest < Rails::Generators::TestCase
  tests ShrineGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end
end
