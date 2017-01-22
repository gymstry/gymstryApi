# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170122200956) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,       null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.string   "telephone"
    t.integer  "gym_id"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["confirmation_token"], name: "index_branches_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_branches_on_email", unique: true, using: :btree
    t.index ["gym_id"], name: "index_branches_on_gym_id", using: :btree
    t.index ["reset_password_token"], name: "index_branches_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_branches_on_uid_and_provider", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_branches_on_unlock_token", unique: true, using: :btree
  end

  create_table "gyms", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,       null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.string   "description"
    t.string   "address"
    t.string   "telephone"
    t.string   "email"
    t.text     "speciality"
    t.date     "birthday"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["confirmation_token"], name: "index_gyms_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_gyms_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_gyms_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_gyms_on_uid_and_provider", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_gyms_on_unlock_token", unique: true, using: :btree
  end

  create_table "trainers", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,       null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.string   "lastname"
    t.string   "telephone"
    t.string   "email"
    t.text     "speciality"
    t.integer  "type"
    t.text     "avatar"
    t.date     "birthday"
    t.string   "username"
    t.integer  "branch_id"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["branch_id"], name: "index_trainers_on_branch_id", using: :btree
    t.index ["confirmation_token"], name: "index_trainers_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_trainers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_trainers_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_trainers_on_uid_and_provider", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_trainers_on_unlock_token", unique: true, using: :btree
    t.index ["username"], name: "index_trainers_on_username", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,       null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "name"
    t.string   "lastname"
    t.string   "username"
    t.text     "avatar"
    t.string   "email"
    t.string   "telephone"
    t.integer  "remaining_days",         default: 0,       null: false
    t.date     "birthday"
    t.integer  "branch_id"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["branch_id"], name: "index_users_on_branch_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

end
