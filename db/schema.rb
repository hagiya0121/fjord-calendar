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

ActiveRecord::Schema[8.0].define(version: 2025_05_22_043004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "calendars", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year"], name: "index_calendars_on_year", unique: true
  end

  create_table "entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "calendar_id", null: false
    t.string "title", null: false
    t.string "url"
    t.date "registration_date", null: false
    t.string "meta_title"
    t.string "meta_description"
    t.text "meta_image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["calendar_id"], name: "index_entries_on_calendar_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "provider_uid", null: false
    t.string "avatar_url"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider", null: false
    t.text "remember_token"
    t.datetime "remember_created_at"
    t.index ["provider", "provider_uid"], name: "index_users_on_provider_and_provider_uid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "entries", "calendars"
  add_foreign_key "entries", "users"
end
