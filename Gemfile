source 'https://rubygems.org'

ruby '2.0.0'

gem 'thin', require: false

gem 'sinatra', '~>1.4', require: 'sinatra/base'
gem 'sinatra-contrib', '~> 1.4'

gem 'mongoid'
gem 'bson_ext'
gem 'bcrypt-ruby', '~> 3.1.2', require: 'bcrypt'

gem 'rack-flash3', '~> 1.0.5',     require: 'rack-flash'
gem 'sinatra-redirect-with-flash', require: 'sinatra/redirect_with_flash'
gem 'sinatra-partial',             require: 'sinatra/partial'

gem 'json'

group :development do
  gem 'awesome_print', require: false
  gem 'rerun',         require: false
  gem 'pry',           require: false
  gem 'faker',         require: false
  gem 'mongo',         require: false
end

group :production do
end
