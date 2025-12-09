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

ActiveRecord::Schema[8.1].define(version: 2025_12_09_143802) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ceu_events", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.decimal "credits", precision: 4, scale: 2
    t.datetime "date"
    t.text "description"
    t.string "event_type"
    t.string "location"
    t.string "provider"
    t.string "timestamps"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["category"], name: "index_ceu_events_on_category"
    t.index ["event_type"], name: "index_ceu_events_on_event_type"
  end

  create_table "ceus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.decimal "duration"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_ceus_on_user_id"
  end

  create_table "issuing_authorities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "license_format_regex"
    t.string "name"
    t.string "state"
    t.datetime "updated_at", null: false
  end

  create_table "professional_licenses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "expiration_date"
    t.bigint "issuing_authority_id", null: false
    t.string "license_number"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["issuing_authority_id"], name: "index_professional_licenses_on_issuing_authority_id"
    t.index ["user_id"], name: "index_professional_licenses_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.string "address_line_1"
    t.string "address_line_2"
    t.text "bio"
    t.date "birthdate"
    t.string "city"
    t.datetime "created_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "middle_initial"
    t.string "phone_number"
    t.string "state"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "zip_code"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ceus", "users"
  add_foreign_key "professional_licenses", "issuing_authorities"
  add_foreign_key "professional_licenses", "users"
  add_foreign_key "user_profiles", "users"
end
