class CreateLoreEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :lore_entries do |t|
      t.string :lore_type, null: false   # faerun, middle_earth
      t.string :category, null: false    # prefix, suffix, smith, wielder, place, event, etc.
      t.string :key                      # grouping key: rarity name, effect_type, category name (nil for flat lists)
      t.text   :value, null: false       # the actual lore text
      t.timestamps
    end

    add_index :lore_entries, [:lore_type, :category, :key]
    add_index :lore_entries, [:lore_type, :category]
  end
end
