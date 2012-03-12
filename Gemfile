source :rubygems
gem "bundler"

gem "rails", "3.2.0"
gem "rake"
gem "gem_plugin"
gem "mime-types"
gem "fastthread"
gem "nokogiri"
gem "httpauth"
gem "acts_as_taggable_on_steroids", :git => "https://github.com/jviney/acts_as_taggable_on_steroids.git"
gem "ruby-openid"
gem "ruby-openid-apps-discovery"
gem "delayed_job"
gem "dynamic_form"
gem "aws-sdk"
gem 'delayed_job_active_record'
gem "daemons"
gem 'jquery-rails'
gem 'pivotal_git_scripts'
gem 'foreman'
gem 'bourbon'
gem 'httpi'

group :postgres do
  gem "pg"
end

group :mysql do
  gem 'mysql2', '~> 0.3.0'
end

group :thin do
  gem "thin"
end

group :assets do
  gem 'sass-rails',"  ~> 3.2.3"
  gem 'uglifier', '>=1.0.3'
end

group :development do
  gem "heroku"
  gem "sqlite3-ruby", "1.3.1"
  gem 'ruby-debug-base19', :platforms => :mri_19
  gem 'ruby-debug-base', :platforms => :mri_18
  gem "ruby-debug-ide"
  gem "capistrano"
  gem "capistrano-ext"
  gem "soloist"
  gem "rvm"
  gem "fog"
end

group :test do
  gem "headless", "0.1.0"
  gem "timecop"
end

group :test, :development do
  gem "rspec-rails"
  gem "capybara"
  gem "jasmine"
end
