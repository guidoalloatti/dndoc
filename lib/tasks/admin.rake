namespace :admin do
  desc "Make a user admin by email. Usage: rails admin:add EMAIL=user@example.com"
  task add: :environment do
    email = ENV["EMAIL"]
    abort "Usage: rails admin:add EMAIL=user@example.com" if email.blank?

    user = User.find_by(email: email)
    abort "User not found: #{email}" unless user

    if user.admin?
      puts "#{email} is already an admin."
    else
      user.update!(admin: true)
      puts "#{email} is now an admin."
    end
  end
end
