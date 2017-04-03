source 'https://rubygems.org'
ruby "2.3.1"



# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'capistrano',         require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false
  gem 'rspec-rails', '~> 3.5'
  gem "factory_girl_rails", "~> 4.0"
  gem 'faker', branch: 'master' , git: 'https://github.com/stympy/faker.git'
end

group :development do
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#Authentication
gem 'devise_token_auth', :git => 'git://github.com/lynndylanhurley/devise_token_auth.git'
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'

#cross-origin
gem 'rack-cors', :require => 'rack/cors'

#request-limit
gem 'rack-attack'

#pagination
gem 'will_paginate', '~> 3.1.0'

#images
gem 'carrierwave', '~> 1.0'
gem "fog"
gem 'mini_magick'

#file validator
gem 'file_validators'

#serializers
gem 'active_model_serializers'

#for testing
gem 'database_cleaner'


#search motor
#gem 'searchkick'
