class StimulusGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def create_stimulus_controller
    # create_file "app/javascript/controllers/#{file_path}_controller.js"
    template 'stimulus_controller.js.erb', "app/javascript/controllers/#{file_path}_controller.js"
  end

end
