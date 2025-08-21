# frozen_string_literal: true

require_relative 'lib/librum/components/version'

Gem::Specification.new do |gem|
  gem.name        = 'librum-components'
  gem.version     = Librum::Components::VERSION
  gem.summary     = 'Component library for Librum applications.'

  description = <<~DESCRIPTION
    A component library for developing Librum applications.
  DESCRIPTION
  gem.description = description.strip.gsub(/\n +/, ' ')
  gem.authors     = ['Rob "Merlin" Smith']
  gem.email       = ['merlin@sleepingkingstudios.com']
  gem.homepage    = 'http://sleepingkingstudios.com'
  gem.license     = 'MIT'

  gem.metadata = {
    'bug_tracker_uri'       => 'https://github.com/sleepingkingstudios/librum-components/issues',
    'source_code_uri'       => 'https://github.com/sleepingkingstudios/librum-components',
    'rubygems_mfa_required' => 'true'
  }

  gem.require_path = 'lib'
  gem.files        = Dir[
    'app/assets/stylesheets/**/*.css',
    'app/javascripts/**/*.js',
    'lib/**/*.rb',
    'LICENSE',
    '*.md'
  ]

  gem.required_ruby_version = '>= 3.4'

  gem.add_dependency 'diffy',           '~> 3.4'
  gem.add_dependency 'plumbum',         '>= 0.1.0.alpha'
  gem.add_dependency 'rails',           '>= 7.0', '< 9'
  gem.add_dependency 'view_component',  '~> 3.21'
end
