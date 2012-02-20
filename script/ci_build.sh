cp config/database.yml.travis config/database.yml
cp config/auth.yml.example config/auth.yml

sh -e /etc/init.d/xvfb start
export DISPLAY=:99

bundle exec rake db:create db:migrate db:test:prepare spec jasmine:ci