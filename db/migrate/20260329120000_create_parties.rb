class CreateParties < ActiveRecord::Migration[7.2]
  def change
    create_table :parties do |t|
      t.string :name, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
