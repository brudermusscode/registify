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

ActiveRecord::Schema[7.0].define(version: 2022_03_27_075042) do
  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.date "born_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "delayed_jobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "cron"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "list_invitations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "use_count", default: 0, null: false
    t.index ["list_id"], name: "index_list_invitations_on_list_id"
  end

  create_table "list_items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "text", null: false
    t.bigint "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "creator_type"
    t.bigint "creator_id"
    t.string "ownable_type"
    t.bigint "ownable_id"
    t.index ["creator_type", "creator_id"], name: "index_list_items_on_creator"
    t.index ["list_id"], name: "index_list_items_on_list_id"
    t.index ["ownable_type", "ownable_id"], name: "index_list_items_on_ownable"
  end

  create_table "list_permissions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "operator_type", null: false
    t.bigint "operator_id", null: false
    t.index ["list_id"], name: "index_list_permissions_on_list_id"
    t.index ["operator_type", "operator_id"], name: "index_list_permissions_on_operator"
  end

  create_table "list_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "requester_type", null: false
    t.bigint "requester_id", null: false
    t.index ["list_id"], name: "index_list_requests_on_list_id"
    t.index ["requester_type", "requester_id"], name: "index_list_requests_on_requester"
  end

  create_table "list_versions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes", size: :long
    t.index ["item_type", "item_id"], name: "index_list_versions_on_item_type_and_item_id"
  end

  create_table "lists", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ownable_type"
    t.bigint "ownable_id"
    t.string "creator_type"
    t.bigint "creator_id"
    t.index ["creator_type", "creator_id"], name: "index_lists_on_creator"
    t.index ["ownable_type", "ownable_id"], name: "index_lists_on_ownable"
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type", null: false
    t.bigint "owner_id", null: false
    t.index ["owner_type", "owner_id"], name: "index_profiles_on_owner"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "born_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "approved_at", default: "2022-04-06 19:21:59"
    t.datetime "freed_at"
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", size: :long
    t.datetime "created_at"
    t.text "object_changes", size: :long
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "list_invitations", "lists"
  add_foreign_key "list_items", "lists"
  add_foreign_key "list_permissions", "lists"
  add_foreign_key "list_requests", "lists"
end
