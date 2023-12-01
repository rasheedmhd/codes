# class InitializerGenerator < Rails::Generators::NamedBase
class InitializerGenerator < Rails::Generators::Base
    # source File.expand_path('templates', __dir__)
    # template "generators/templates", "app/lib/initializer.rb"

    desc "This generator creates an initializer file at config/initializers"

    def create_initializer_file

        create_file "config/initializers/initializer.rb"
        # <<~RUBY
        # # Add initialization content here
        # RUBY
        
    end
end