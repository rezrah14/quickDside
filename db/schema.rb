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

ActiveRecord::Schema[7.0].define(version: 2023_12_18_033502) do
  create_table "asset_tags", force: :cascade do |t|
    t.integer "asset_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_asset_tags_on_asset_id"
    t.index ["tag_id"], name: "index_asset_tags_on_tag_id"
  end

  create_table "assets", force: :cascade do |t|
    t.string "region"
    t.string "company_name"
    t.integer "asset_type"
    t.date "start_date"
    t.date "end_date"
    t.integer "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["project_id"], name: "index_assets_on_project_id"
  end

  create_table "components", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "project_id", null: false
    t.integer "quantity_type", default: 0
    t.integer "unit_multiplier", default: 2
    t.integer "unit", default: 0
    t.integer "price_interpolation_model", default: 0
    t.integer "currency", default: 0
  end

  create_table "project_invitations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.string "email", null: false
    t.integer "access_level", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "inviter_id"
    t.string "token"
    t.string "first_name"
    t.string "last_name"
    t.index ["project_id"], name: "index_project_invitations_on_project_id"
    t.index ["user_id"], name: "index_project_invitations_on_user_id"
  end

  create_table "project_users", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
    t.integer "access_level", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_users_on_project_id"
    t.index ["user_id", "project_id"], name: "index_project_users_on_user_id_and_project_id", unique: true
    t.index ["user_id"], name: "index_project_users_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.integer "length", default: 100
    t.integer "monthly_resolution_end_year", default: 1
    t.date "start_date"
    t.json "time_intervals", default: []
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "project_id", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "time_series_attributes", force: :cascade do |t|
    t.string "name"
    t.integer "interpolation_model"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attributable_type", null: false
    t.integer "attributable_id", null: false
    t.index ["attributable_type", "attributable_id"], name: "index_time_series_attributes_on_attributable"
  end

  create_table "time_series_data_points", force: :cascade do |t|
    t.integer "time_series_attribute_id", null: false
    t.date "date"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["time_series_attribute_id"], name: "index_time_series_data_points_on_time_series_attribute_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "verification_token"
    t.boolean "verified"
    t.index ["verification_token"], name: "index_users_on_verification_token"
  end

  add_foreign_key "asset_tags", "assets"
  add_foreign_key "asset_tags", "tags"
  add_foreign_key "assets", "projects"
  add_foreign_key "components", "projects"
  add_foreign_key "project_invitations", "projects"
  add_foreign_key "project_invitations", "users"
  add_foreign_key "project_users", "projects"
  add_foreign_key "project_users", "users"
  add_foreign_key "projects", "users", column: "owner_id"
  add_foreign_key "time_series_data_points", "time_series_attributes"
end
