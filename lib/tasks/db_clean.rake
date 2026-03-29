namespace :db do
  desc "Drop all tables, re-create schema and seed. Handles FK constraints."
  task nuke: :environment do
    puts "⚠ This will destroy ALL data in #{Rails.env} database."
    puts "Press Ctrl+C to cancel, or wait 3 seconds..."
    sleep 3 unless Rails.env.test?

    conn = ActiveRecord::Base.connection

    # Disable FK checks, drop everything, re-enable
    conn.execute("SET session_replication_role = 'replica';") # disables FK triggers

    tables = conn.tables - ["schema_migrations", "ar_internal_metadata"]
    tables.each do |table|
      puts "  Truncating #{table}..."
      conn.execute("TRUNCATE TABLE #{conn.quote_table_name(table)} CASCADE;")
    end

    conn.execute("SET session_replication_role = 'origin';") # re-enable FK triggers

    puts "All tables truncated. Running seeds..."
    Rake::Task["db:seed"].invoke
    puts "Done!"
  end
end
