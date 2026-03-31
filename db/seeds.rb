# ══════════════════════════════════════════════════════════════════
# DnDoc Database Seeds — Coordinator
# ══════════════════════════════════════════════════════════════════
# Individual seed files live in db/seeds/*.rb (numbered for order).
# Run a specific file:  rails db:seed:file[05_effects]
# List available files: rails db:seed:list
# ══════════════════════════════════════════════════════════════════

puts "-------------------------------------------"
puts "Welcome to the DnDoc database seeding script!"
puts "Before we proceed, please note that running this script will reset"
puts "the database and delete all existing records."
puts "-------------------------------------------"

if ENV["FORCE_SEED"] == "1"
  puts "FORCE_SEED=1 detected — skipping confirmation."
  answer = "yes"
elsif $stdin.isatty
  puts "Do you want to reset the database? (yes/y to confirm, anything else to cancel)"
  answer = $stdin.gets.chomp.downcase
else
  puts "Non-interactive environment — skipping. Use FORCE_SEED=1 to run without prompt."
  answer = "no"
end

unless answer == "yes" || answer == "y"
  puts "Seeding cancelled."
  return
end

puts "Cleaning the DB..."
ActiveRecord::Base.connection.execute("DELETE FROM categories_effects")
puts "  Destroyed categories_effects"
ActiveRecord::Base.connection.execute("DELETE FROM class_category_affinities") if ActiveRecord::Base.connection.table_exists?("class_category_affinities")
puts "  Destroyed class_category_affinities"
ItemEffect.destroy_all
puts "  Destroyed item_effects"
Item.destroy_all
puts "  Destroyed items"
Effect.destroy_all
puts "  Destroyed effects"
Category.destroy_all
puts "  Destroyed categories"
Rarity.destroy_all
puts "  Destroyed rarities"
Weapon.destroy_all
puts "  Destroyed weapons"
Armor.destroy_all
puts "  Destroyed armors"
CharacterClass.destroy_all
puts "  Destroyed character_classes"
LoreEntry.delete_all if defined?(LoreEntry)
puts "  Destroyed lore_entries"
puts "------------- All is clean! -------------"
puts

puts "------------- Starting to seed the database... -------------"

Dir[Rails.root.join('db/seeds/*.rb')].sort.each do |file|
  puts "\n>>> Loading #{File.basename(file)}..."
  load file
end

puts
puts "============================================="
puts "Seeding complete!"
puts "  Weapons:          #{Weapon.count}"
puts "  Armors:           #{Armor.count}"
puts "  Categories:       #{Category.count}"
puts "  Rarities:         #{Rarity.count}"
puts "  Effects:          #{Effect.count}"
puts "  Character Classes: #{CharacterClass.count}"
puts "  Lore Entries:     #{defined?(LoreEntry) ? LoreEntry.count : 0}"
puts "============================================="
