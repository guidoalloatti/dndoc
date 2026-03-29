class CreateCharacterClasses < ActiveRecord::Migration[7.2]
  def change
    create_table :character_classes do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :is_magic_user, default: false

      t.timestamps
    end

    add_index :character_classes, :name, unique: true
  end
end
