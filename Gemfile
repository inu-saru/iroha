source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem 'rack-cors'
gem 'devise'
gem 'devise-jwt'
gem 'alba'
gem 'pagy', '~> 6.0'
gem 'faraday'
gem 'faraday_middleware'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'gimei'
  gem 'ffaker'
  gem 'rspec-rails', '~> 6.0.0'
  gem 'rspec-request_describer'
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

gem "dockerfile-rails", ">= 1.5", :group => :development
