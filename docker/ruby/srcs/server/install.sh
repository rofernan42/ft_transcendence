rm tmp/pids/server.pid
bundle install
yarn install --check-files
rails db:migrate
rails db:setup
