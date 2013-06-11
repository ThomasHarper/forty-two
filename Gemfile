source 'https://rubygems.org'

# User Ruby 2.0
ruby "2.0.0"


gem 'rails', '3.2.13'		  # Ruby on Rails
gem "foreman"               # Server management
gem "unicorn", "~> 4.6.2"	   # HTTP server
gem "dalli", "~> 2.6.4"       # High performance memcached client for Ruby
gem "heroku", "~> 2.39.4"      # Client library and command-line tool to deploy and manage apps on Heroku


group :production, :staging do
  gem "pg"
end

group :development, :test do
	gem "sqlite3-ruby", "~> 1.3.0", :require => "sqlite3"
	gem "faker", "1.0.1"
	gem "spork", "~> 0.9.2"
	gem "rspec-rails"
	gem "factory_girl_rails", "~> 4.2.1"
	gem "cucumber", "1.2.5"
	gem "cucumber-rails", "1.3.0", :require => false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem "bootstrap-sass", "~> 2.3.1.3"
  gem "haml", "~> 4.0.3"
  gem "rails-i18n", "~> 0.7.3"
  gem "globalize3", "~> 0.3.0"
  gem "friendly_id", "~> 4.0.9"
  gem 'jquery-rails'
  gem 'uglifier', '>= 1.0.3'
end




