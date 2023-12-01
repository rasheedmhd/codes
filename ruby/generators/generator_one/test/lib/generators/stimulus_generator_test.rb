require "test_helper"
require "generators/stimulus/stimulus_generator"

class StimulusGeneratorTest < Rails::Generators::TestCase
  tests StimulusGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  # test "generator runs without errors" do
  #   assert_nothing_raised do
  #     run_generator ["arguments"]
  #   end
  # end

  test 'should add thing controller file' do
    run_generator ['Thing']

    assert_file 'app/javascript/controllers/thing_controller.js'
  end

  test 'should add stimulusjs boilerplate' do
    run_generator ['Thing']
    assert_file "app/javascript/controllers/thing_controller.js" do |content|
     assert_match /Controller/, content
     assert_match /connect()/, content
     assert_match /@hotwired/, content
    end
   end
end
