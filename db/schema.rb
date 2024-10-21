# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_16_041833) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "min_weight"
    t.integer "max_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_effects", id: false, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "effect_id", null: false
    t.index ["category_id"], name: "index_categories_effects_on_category_id"
    t.index ["effect_id"], name: "index_categories_effects_on_effect_id"
  end

  create_table "effects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "effect_type"
    t.integer "power_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_effects", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "effect_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["effect_id"], name: "index_item_effects_on_effect_id"
    t.index ["item_id"], name: "index_item_effects_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "item_type"
    t.integer "power"
    t.string "weight"
    t.integer "price"
    t.boolean "requires_attunement"
    t.bigint "category_id", null: false
    t.bigint "rarity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["rarity_id"], name: "index_items_on_rarity_id"
  end

  create_table "rarities", force: :cascade do |t|
    t.string "name"
    t.integer "min_price"
    t.integer "max_price"
    t.integer "min_power"
    t.integer "max_power"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name"
    t.integer "cost"
    t.string "damage"
    t.float "weight"
    t.text "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories_effects", "categories"
  add_foreign_key "categories_effects", "effects"
  add_foreign_key "item_effects", "effects"
  add_foreign_key "item_effects", "items"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "rarities"
end
