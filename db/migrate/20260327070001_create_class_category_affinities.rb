class CreateClassCategoryAffinities < ActiveRecord::Migration[7.2]
  def change
    create_table :class_category_affinities do |t|
      t.references :character_class, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.integer :weight, default: 1, null: false
    end

    add_index :class_category_affinities, [:character_class_id, :category_id],
              unique: true, name: "idx_class_category_affinity_unique"
  end
end
