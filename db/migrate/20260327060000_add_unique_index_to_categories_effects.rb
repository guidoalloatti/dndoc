class AddUniqueIndexToCategoriesEffects < ActiveRecord::Migration[7.2]
  def up
    execute <<-SQL
      DELETE FROM categories_effects a
      USING categories_effects b
      WHERE a.ctid < b.ctid
        AND a.category_id = b.category_id
        AND a.effect_id = b.effect_id
    SQL

    add_index :categories_effects, [:category_id, :effect_id], unique: true, name: "index_categories_effects_on_category_and_effect"
  end

  def down
    remove_index :categories_effects, name: "index_categories_effects_on_category_and_effect"
  end
end
