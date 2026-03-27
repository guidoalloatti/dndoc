#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate

# Seed the database only on first deploy (when tables are empty)
if bundle exec rails runner "exit(Category.count == 0 ? 0 : 1)" 2>/dev/null; then
  echo "Seeding database..."
  bundle exec rake db:seed
fi

# Ensure admin user exists
bundle exec rails runner "
  admin_email = ENV['ADMIN_EMAIL'] || 'guidoalloatti@gmail.com'
  user = User.find_by(email: admin_email)
  if user && !user.admin?
    user.update_column(:admin, true)
    puts \"Admin granted to #{admin_email}\"
  elsif user
    puts \"#{admin_email} is already admin\"
  else
    puts \"User #{admin_email} not found yet — will be set as admin on next deploy after registration\"
  end
"
