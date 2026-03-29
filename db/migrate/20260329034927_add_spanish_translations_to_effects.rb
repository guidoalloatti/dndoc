class AddSpanishTranslationsToEffects < ActiveRecord::Migration[7.2]
  def change
    add_column :effects, :name_es, :string
    add_column :effects, :description_es, :text
  end
end
