class CreateAll < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.integer :min_weight 
      t.integer :max_weight 

      t.timestamps
    end

    create_table :rarities do |t|
      t.string :name
      t.integer :min_price
      t.integer :max_price
      t.integer :min_power
      t.integer :max_power

      t.timestamps
    end

    create_table :effects do |t|
      t.string :name
      t.text :description
      t.string :effect_type
      t.integer :power_level

      t.timestamps
    end

    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :item_type, null: true
      t.integer :power
      t.string :weight
      t.integer :price
      t.boolean :requires_attunement

      t.references :category, null: false, foreign_key: true
      t.references :rarity, null: false, foreign_key: true
      
      t.timestamps
    end

    create_table :categories_effects, id: false do |t|
      t.references :category, null: false, foreign_key: true
      t.references :effect, null: false, foreign_key: true
    end

    create_table :item_effects do |t|
      t.references :item, null: false, foreign_key: true
      t.references :effect, null: false, foreign_key: true

      t.timestamps
    end

    create_table :weapons do |t|
      t.string :name
      t.integer :cost
      t.string :damage
      t.float :weight
      t.text :properties

      t.timestamps
    end
  end
end


