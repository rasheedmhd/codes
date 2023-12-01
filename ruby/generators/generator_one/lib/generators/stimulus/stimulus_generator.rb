class StimulusGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  # When taking arguments in our generators, we can use the class_option method.
  class_option :actions, type: :array, default: []

  def create_stimulus_controller
    # create_file "app/javascript/controllers/#{file_path}_controller.js"
    template 'stimulus_controller.js.erb', "app/javascript/controllers/#{file_path}_controller.js"
  end

end
