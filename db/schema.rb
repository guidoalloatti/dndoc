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

ActiveRecord::Schema[7.2].define(version: 2026_03_27_030000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.bigint "user_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["rarity_id"], name: "index_items_on_rarity_id"
    t.index ["user_id"], name: "index_items_on_user_id"
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

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar_url"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories_effects", "categories"
  add_foreign_key "categories_effects", "effects"
  add_foreign_key "item_effects", "effects"
  add_foreign_key "item_effects", "items"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "rarities"
  add_foreign_key "items", "users"
end
