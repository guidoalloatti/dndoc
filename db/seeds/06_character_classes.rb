puts "Creating Character Classes..."
classes_data = [
  { name: "Barbarian",  description: "A fierce warrior who channels primal rage in battle",           is_magic_user: false },
  { name: "Bard",       description: "A spellcaster who weaves magic through music and performance",  is_magic_user: true },
  { name: "Cleric",     description: "A divine spellcaster empowered by a deity",                     is_magic_user: true },
  { name: "Druid",      description: "A nature spellcaster who draws power from the natural world",   is_magic_user: true },
  { name: "Fighter",    description: "A master of martial combat and tactical warfare",               is_magic_user: false },
  { name: "Monk",       description: "A martial artist who channels ki energy",                       is_magic_user: false },
  { name: "Paladin",    description: "A holy warrior bound by a sacred oath",                         is_magic_user: true },
  { name: "Ranger",     description: "A wilderness warrior with nature magic",                        is_magic_user: true },
  { name: "Rogue",      description: "A skilled trickster who uses stealth and cunning",              is_magic_user: false },
  { name: "Sorcerer",   description: "A spellcaster with innate magical power",                       is_magic_user: true },
  { name: "Warlock",    description: "A spellcaster who draws power from a patron",                   is_magic_user: true },
  { name: "Wizard",     description: "A scholarly spellcaster who studies the arcane arts",            is_magic_user: true },
  { name: "Artificer",  description: "A master of magical invention and infusion",                    is_magic_user: true },
]
classes_data.each do |class_attrs|
  CharacterClass.create!(class_attrs)
end

# ── Category affinities per class ──
# Weight: 3 = high affinity, 2 = medium, 1 = low
puts "Creating Class-Category Affinities..."

affinities = {
  "Barbarian" => {
    "Weapons" => 3, "Armor" => 3, "Shields" => 2, "Boots" => 2, "Helms" => 2,
    "Amulets" => 1, "Rings" => 1, "Potions" => 1, "Gloves" => 1
  },
  "Bard" => {
    "Wands" => 2, "Rings" => 3, "Amulets" => 3, "Scrolls" => 2, "Books" => 2,
    "Cloak" => 2, "Boots" => 2, "Potions" => 1, "Weapons" => 1, "Horns" => 3
  },
  "Cleric" => {
    "Armor" => 2, "Shields" => 3, "Staffs" => 2, "Amulets" => 3, "Scrolls" => 2,
    "Potions" => 2, "Helms" => 1, "Rings" => 1, "Weapons" => 1
  },
  "Druid" => {
    "Staffs" => 3, "Amulets" => 2, "Rings" => 2, "Potions" => 3, "Elixirs" => 3,
    "Potent Ingredients" => 2, "Cloak" => 2, "Boots" => 2, "Gems" => 1
  },
  "Fighter" => {
    "Weapons" => 3, "Armor" => 3, "Shields" => 3, "Helms" => 2, "Boots" => 2,
    "Gloves" => 2, "Ammunition" => 2, "Rings" => 1, "Amulets" => 1, "Potions" => 1
  },
  "Monk" => {
    "Gloves" => 3, "Boots" => 3, "Amulets" => 2, "Rings" => 2, "Bracelet" => 3,
    "Cloak" => 2, "Potions" => 1, "Weapons" => 1
  },
  "Paladin" => {
    "Weapons" => 3, "Armor" => 3, "Shields" => 3, "Amulets" => 2, "Helms" => 2,
    "Rings" => 1, "Potions" => 1, "Scrolls" => 1
  },
  "Ranger" => {
    "Weapons" => 3, "Ammunition" => 3, "Armor" => 2, "Boots" => 3, "Cloak" => 3,
    "Gloves" => 2, "Rings" => 1, "Amulets" => 1, "Potions" => 1
  },
  "Rogue" => {
    "Weapons" => 2, "Cloak" => 3, "Boots" => 3, "Gloves" => 3, "Rings" => 2,
    "Amulets" => 1, "Potions" => 1, "Tools" => 2, "Trinkets" => 2
  },
  "Sorcerer" => {
    "Wands" => 3, "Staffs" => 2, "Rings" => 3, "Amulets" => 3, "Gems" => 2,
    "Scrolls" => 2, "Cloak" => 2, "Potions" => 1
  },
  "Warlock" => {
    "Wands" => 3, "Staffs" => 2, "Rings" => 3, "Amulets" => 3, "Scrolls" => 2,
    "Gems" => 2, "Books" => 2, "Cloak" => 1
  },
  "Wizard" => {
    "Wands" => 3, "Staffs" => 3, "Scrolls" => 3, "Books" => 3, "Rings" => 2,
    "Amulets" => 2, "Gems" => 2, "Potions" => 1
  },
  "Artificer" => {
    "Wands" => 3, "Tools" => 3, "Armor" => 2, "Rings" => 2, "Amulets" => 2,
    "Weapons" => 2, "Potions" => 2, "Scrolls" => 1, "Gems" => 1
  },
}

affinities.each do |class_name, categories|
  char_class = CharacterClass.find_by!(name: class_name)
  categories.each do |cat_name, weight|
    cat = Category.find_by(name: cat_name)
    next unless cat
    ClassCategoryAffinity.create!(character_class: char_class, category: cat, weight: weight)
  end
end

puts "Character Classes created: #{CharacterClass.count}"
