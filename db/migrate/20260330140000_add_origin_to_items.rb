class AddOriginToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :origin, :string, default: "Desconocido"
  end
end
