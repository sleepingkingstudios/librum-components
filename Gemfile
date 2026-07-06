# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in librum-components.gemspec.
gemspec

gem 'rails', '~> 8.1'
gem 'view_component', '~> 4.10'

gem 'plumbum', '~> 0.1'
gem 'sleeping_king_studios-tools', '~> 1.3'

group :development, :test do
  gem 'byebug', '~> 11.1'

  gem 'cuprum-rails',
    git: 'https://github.com/sleepingkingstudios/cuprum-rails'

  gem 'rspec', '~> 3.13'
  gem 'rspec-sleeping_king_studios', '~> 2.8', '>= 2.8.4'
  gem 'simplecov', '~> 0.22'

  gem 'rubocop', '~> 1.86'
  gem 'rubocop-factory_bot', '~> 2.28'
  gem 'rubocop-rails', '~> 2.35'
  gem 'rubocop-rspec', '~> 3.9'
  gem 'rubocop-rspec_rails', '~> 2.32'

  gem 'sleeping_king_studios-tasks',
    git: 'https://github.com/sleepingkingstudios/sleeping_king_studios-tasks'
end

group :doc do
  gem 'jekyll', '~> 4.3'
  gem 'kramdown', '~> 2.5'
  gem 'sleeping_king_studios-docs', '~> 0.2'
  gem 'webrick', '~> 1.9' # Use Webrick as local content server.
  gem 'yard', '~> 0.9', require: false
end
