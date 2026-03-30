class MergeDuplicateShadowVeilEffects < ActiveRecord::Migration[7.2]
  def up
    veil_of_shadows = Effect.find_by(name: "Veil of Shadows")
    shadow_veil = Effect.find_by(name: "Shadow Veil")

    return unless veil_of_shadows && shadow_veil

    # Move all item associations from "Veil of Shadows" to "Shadow Veil"
    veil_of_shadows_item_ids = veil_of_shadows.items.pluck(:id)
    shadow_veil_item_ids = shadow_veil.items.pluck(:id)

    # Only add associations that don't already exist
    new_item_ids = veil_of_shadows_item_ids - shadow_veil_item_ids
    new_item_ids.each do |item_id|
      execute "INSERT INTO item_effects (item_id, effect_id) VALUES (#{item_id}, #{shadow_veil.id})"
    end

    # Add any category associations from Veil of Shadows that Shadow Veil doesn't have
    veil_cat_ids = veil_of_shadows.categories.pluck(:id)
    shadow_cat_ids = shadow_veil.categories.pluck(:id)
    (veil_cat_ids - shadow_cat_ids).each do |cat_id|
      execute "INSERT INTO categories_effects (category_id, effect_id) VALUES (#{cat_id}, #{shadow_veil.id})"
    end

    # Remove all associations and delete the duplicate
    execute "DELETE FROM item_effects WHERE effect_id = #{veil_of_shadows.id}"
    execute "DELETE FROM categories_effects WHERE effect_id = #{veil_of_shadows.id}"
    veil_of_shadows.destroy!
  end

  def down
    # No rollback — the duplicate was intentionally removed
  end
end
