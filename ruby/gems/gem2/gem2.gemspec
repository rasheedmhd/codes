# frozen_string_literal: true

require File.expand_path('lib/gem2/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'gem2'
  spec.version = Gem2.version
  spec.authors = ['Rasheed Starlet']
  spec.email = ['starletgh@gmail.com']
  spec.summary = 'Testing Gems, Gem2 for RoR'
  spec.description = 'This gem allows to me a space to experiment with building RubyGems'
  spec.homepage = 'https://githubh.com/rasheedmhd/ruby/gems'
  spec.license = 'MIT'
  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 2.5.0'

  spec.files = Dir[
      'README.md',
      'CHANGELOG.md',
      'lib/**/*.rb',
      'lib/**/*.rake',
      'gem2.gemspec',
      '.github/*.md',
      'Gemfile',
      'Rakefile'
  ]
  spec.extra_rdoc_files = ['README.md']
  # spec.add_dependency 'ruby-gem2-api', '~> 3.1'
  spec.add_dependency 'rubyzip', '~> 2.3'
  spec.add_development_dependency 'rubocop', '~> 0.60'
  spec.add_development_dependency 'rubocop-performance', '~> 1.5'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.37'
end
