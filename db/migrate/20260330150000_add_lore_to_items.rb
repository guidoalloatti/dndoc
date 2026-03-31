class AddLoreToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :lore, :string, default: "faerun"
  end
end
