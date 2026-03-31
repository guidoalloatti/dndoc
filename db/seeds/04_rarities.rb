puts "Creating Rarities..."
Rarity.create!([
  { name: "Common", min_price: 1, max_price: 250, min_power: 0, max_power: 1 },
  { name: "Uncommon", min_price: 250, max_price: 1000, min_power: 2, max_power: 2 },
  { name: "Rare", min_price: 1000, max_price: 5000, min_power: 3, max_power: 4 },
  { name: "Very Rare", min_price: 5000, max_price: 25000, min_power: 5, max_power: 6 },
  { name: "Legendary", min_price: 25000, max_price: 250000, min_power: 7, max_power: 8 },
  { name: "Ancestral", min_price: 75000, max_price: 1000000, min_power: 9, max_power: 10 },
])
puts "Rarities created: #{Rarity.count}"
