#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
npm install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

# Seed the database only on first deploy (when tables are empty)
if bundle exec rails runner "exit(Category.count == 0 ? 0 : 1)" 2>/dev/null; then
  echo "Seeding database..."
  bundle exec rake db:seed
fi
