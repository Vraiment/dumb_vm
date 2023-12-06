# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in dumb_vm.gemspec
gemspec

gem 'rake', '~> 13.0'

gem 'rspec', '~> 3.0'
gem 'rspec-sorbet'

gem 'bigdecimal'

gem 'rubocop', '~> 1.21'
gem 'rubocop-rake', require: false
gem 'rubocop-rspec', require: false

gem 'sorbet', group: :development
gem 'sorbet-runtime'

group :development, :test do
  gem 'tapioca', require: false
end

gem 'yard', group: :development
