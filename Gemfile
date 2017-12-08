source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'

# Use Puma as the app server
gem 'puma', '~> 3.7'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'


gem 'bcrypt', '~> 3.1.7' # Use ActiveModel has_secure_password
gem 'jwt'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors' # Allow CORS

group :development, :test do
  gem 'sqlite3' # Use sqlite3

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug'
  gem 'rspec-rails' # Great Expectations
  gem 'factory_bot_rails' # Assembly The Testing Models
  gem 'shoulda-matchers', '~> 3.1' # Should Coulda Woulda
  gem 'faker' # The Fakest of the Fake
  gem 'database_cleaner' # Database Janitor
  gem 'awesome_print'
  gem 'fuubar'
  gem 'irbtools', require: 'irbtools/binding'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring' # Make The App Springy
  gem 'spring-watcher-listen' # Watch The Springy App
  gem 'better_errors' # Better Errors
  gem 'binding_of_caller' # Better Debugging
end

group :test do
  gem 'simplecov', :require => false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # What day is it?
