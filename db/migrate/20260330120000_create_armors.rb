class CreateArmors < ActiveRecord::Migration[7.2]
  def change
    create_table :armors do |t|
      t.string  :name,                 null: false
      t.string  :armor_type,           null: false   # Light, Medium, Heavy, Shield
      t.string  :armor_class,          null: false   # e.g. "11 + Dex mod", "14 + Dex mod (max 2)", "18"
      t.integer :cost,                 default: 0    # in gp
      t.float   :weight,               default: 0    # in lbs
      t.integer :str_requirement                     # minimum Strength, nullable
      t.boolean :stealth_disadvantage, default: false, null: false
      t.text    :properties                          # extra notes

      t.timestamps
    end
  end
end
