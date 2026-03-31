namespace :db do
  namespace :seed do
    desc "Run a specific seed file. Usage: rails db:seed:file[05_effects]"
    task :file, [:name] => :environment do |_t, args|
      unless args[:name].present?
        puts "Usage: rails db:seed:file[filename_without_extension]"
        puts "Example: rails db:seed:file[05_effects]"
        puts "Run 'rails db:seed:list' to see available files."
        exit 1
      end

      name = args[:name]
      name = name.end_with?(".rb") ? name : "#{name}.rb"
      file = Rails.root.join("db/seeds/#{name}")

      unless File.exist?(file)
        puts "Seed file not found: db/seeds/#{name}"
        puts "Run 'rails db:seed:list' to see available files."
        exit 1
      end

      puts "Running db/seeds/#{name}..."
      load file
      puts "Done!"
    end

    desc "List available individual seed files"
    task list: :environment do
      files = Dir[Rails.root.join('db/seeds/*.rb')].sort
      if files.empty?
        puts "No seed files found in db/seeds/"
      else
        puts "Available seed files:"
        files.each do |f|
          puts "  #{File.basename(f, '.rb')}"
        end
        puts "\nRun with: rails db:seed:file[filename]"
      end
    end
  end
end
