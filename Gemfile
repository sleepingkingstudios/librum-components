# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in librum-core.gemspec.
gemspec

gem 'sleeping_king_studios-tools',
  '>= 1.2.0.alpha',
  git:    'https://github.com/sleepingkingstudios/sleeping_king_studios-tools.git',
  branch: 'main'

group :development, :test do
  gem 'byebug', '~> 11.1'

  gem 'rspec', '~> 3.13'
  gem 'rspec-sleeping_king_studios',
    '>= 2.8.0.alpha',
    git:    'https://github.com/sleepingkingstudios/rspec-sleeping_king_studios.git',
    branch: 'main'
  gem 'simplecov', '~> 0.22'

  gem 'rubocop', '~> 1.71'
  gem 'rubocop-rspec', '~> 3.4'
end

group :doc do
  gem 'jekyll', '~> 4.3'
  gem 'kramdown', '~> 2.5'
  gem 'sleeping_king_studios-yard',
    git:    'https://github.com/sleepingkingstudios/sleeping_king_studios-yard.git',
    branch: 'main'
  gem 'webrick', '~> 1.9' # Use Webrick as local content server.
  gem 'yard', '~> 0.9',  require: false
end
