source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

# Core Framework
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'rails', '~> 7.1.0'

# Authentication & Security
gem 'bcrypt', '~> 3.1.7' # Required for Devise to hash passwords
gem 'devise'
gem 'devise-jwt'
gem 'rack-cors'

# Background Processing
gem 'redis', '~> 5.0'
gem 'solid_queue'

# API Architecture
gem 'aasm' # Car state machine
gem 'active_model_serializers', '~> 0.10.13'
gem 'rswag-api'
gem 'rswag-ui'

# Infrastructure & Optimization
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

# Security & Monitoring Implementation ---

# Rate Limiting: Prevents brute-force attacks on login/car-booking endpoints.
# Implement in config/initializers/rack_attack.rb later.
gem 'rack-attack'

# Error Tracking: Capture 500 errors in production before users report them.
# Use Sentry or Honeybadger (Sentry -> free tier for portfolios).
gem 'sentry-rails'
gem 'sentry-ruby'

group :development, :test do
  gem 'dotenv-rails'
  gem 'bullet'
  gem 'database_cleaner-active_record'
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rswag-specs'

  # Linters
  gem 'rubocop', '>= 1.0', '< 2.0', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end


