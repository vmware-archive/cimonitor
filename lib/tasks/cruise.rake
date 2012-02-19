task :cruise do

  require "headless"

  sh 'rake db:migrate'
  sh 'rake db:schema:load RAILS_ENV=test'
  sh 'rake spec'
  sh 'ps auxwww'
  sh 'netstat -lnptu'
  sh 'rake jasmine:ci'

#  `rake setup && rake db:migrate && rake db:schema:load RAILS_ENV=test && rake spec && rake jasmine:ci`
end