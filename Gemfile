source 'https://rubygems.org'
#ruby=ruby-2.0.0-p451

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

#image upload
gem 'remotipart'
gem 'mini_magick'
gem 'carrierwave'

gem "aasm"

gem "rails-alertify"
gem 'kaminari'
gem 'wisper'

gem 'devise'
#work with devise
gem 'cancan'
gem 'rolify'

gem 'ckeditor'
gem 'ransack', github: 'activerecord-hackery/ransack', branch: 'rails-4.1'
gem 'simple_form'

gem 'recaptcha', :require => "recaptcha/rails"

gem 'mailgun_rails'
# https://github.com/comfy/active_link_to
#gem 'active_link_to'

gem 'whenever', :require => false
gem 'sucker_punch', '~> 1.0'

gem 'activemerchant'

group :production, :staging do
  gem 'mysql2'
end

group :development do
  gem 'thin'
  gem 'meta_request'
  #gem 'faker'
  #gem 'populator'
  #gem 'brakeman', :require => false
  gem 'sqlite3'
  #gem 'sextant'
  gem 'xray-rails'
  gem 'capistrano', "3.0.1"
  gem 'capistrano-rvm'
  gem 'capistrano-ext'

end
