source 'https://rubygems.org'
gem 'rails', '3.2.8'
group :development, :test do
 # gem 'sqlite3'
   gem 'pg'
end
group :production do
  gem 'thin'

  gem 'pg'
end

gem 'pusher'
gem 'gravatar-ultimate'
gem 'will_paginate'
gem 'acts-as-taggable-on'

#### facebook #########
gem 'omniauth'
gem 'omniauth-facebook'
gem 'oauth2'
gem 'koala'
###########################
gem 'delayed_job_active_record'
gem 'rest-client'
gem 'ransack'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "unicorn", ">= 4.3.1", :group => :production
gem "rspec-rails", ">= 2.11.0", :group => [:development, :test]
gem "email_spec", ">= 1.2.1", :group => :test
gem "cucumber-rails", ">= 1.3.0", :group => :test, :require => false
gem "database_cleaner", ">= 0.9.1", :group => :test
gem "launchy", ">= 2.1.2", :group => :test
gem "capybara", ">= 1.1.2", :group => :test
gem "factory_girl_rails", ">= 4.1.0", :group => [:development, :test]
gem "bootstrap-sass", ">= 2.1.0.0"
gem "devise", ">= 2.1.2"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "quiet_assets", ">= 1.0.1", :group => :development
gem "therubyracer", ">= 0.10.2", :group => :assets, :platform => :ruby
gem "hub", ">= 1.10.2", :require => nil, :group => [:development]
gem "thin", :group => :development
gem 'letter_opener', :group => :development
