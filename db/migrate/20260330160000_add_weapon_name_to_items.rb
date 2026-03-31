class AddWeaponNameToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :weapon_name, :string
  end
end
