# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in librum-core.gemspec.
gemspec

gem 'sleeping_king_studios-tools', '~> 1.2'

group :development, :test do
  gem 'byebug', '~> 11.1'

  gem 'rspec', '~> 3.13'
  gem 'rspec-sleeping_king_studios', '~> 2.8', '>= 2.8.1'
  gem 'simplecov', '~> 0.22'

  gem 'rubocop', '~> 1.79'
  gem 'rubocop-factory_bot', '~> 2.27'
  gem 'rubocop-rails', '~> 2.33'
  gem 'rubocop-rspec', '~> 3.6'
  gem 'rubocop-rspec_rails', '~> 2.31'

  gem 'sleeping_king_studios-tasks',
    git: 'https://github.com/sleepingkingstudios/sleeping_king_studios-tasks'
end

group :doc do
  gem 'jekyll', '~> 4.3'
  gem 'kramdown', '~> 2.5'
  gem 'sleeping_king_studios-docs', '~> 0.2'
  gem 'webrick', '~> 1.9' # Use Webrick as local content server.
  gem 'yard', '~> 0.9',  require: false
end
