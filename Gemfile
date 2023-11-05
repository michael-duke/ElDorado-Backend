source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4'

# Use Rubocop for linters
gem 'rubocop', '>= 1.0', '< 2.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use for hiding credentials
gem 'dotenv-rails'

# Use for Devise Authentication
gem 'devise'

# Use for Devise JWT
gem 'devise-jwt'

# Use active model serilizers to serialize API responses
gem 'active_model_serializers', '~> 0.10.13'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Use RSwag to generate Swagger documentation
gem 'rswag'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  # Use bullet to fix N + 1 problems
  gem 'bullet'
  # Use for testing models and controllers
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rswag-specs'
  # Use database_cleaner for making Capybara testing
  gem 'database_cleaner'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
