class ShrineGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def setup_shrine
    copy_file 'shrine/shrine_attachment.rb', "app/models/shrine_#{file_name}.rb"
  end
end
