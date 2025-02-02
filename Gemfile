# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in librum-core.gemspec.
gemspec

group :doc do
  gem 'jekyll', '~> 4.3'
  gem 'kramdown', '~> 2.5'
  gem 'sleeping_king_studios-yard',
    git:    'https://github.com/sleepingkingstudios/sleeping_king_studios-yard.git',
    branch: 'main'
  gem 'webrick', '~> 1.9' # Use Webrick as local content server.
  gem 'yard', '~> 0.9',  require: false
end
