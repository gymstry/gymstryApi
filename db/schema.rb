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

ActiveRecord::Schema.define(version: 20170204032706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
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
    t.string   "username"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_admins_on_uid_and_provider", unique: true, using: :btree
  end

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

  create_table "challanges", force: :cascade do |t|
    t.string   "name",                                  null: false
    t.text     "description",    default: ""
    t.integer  "type_challange"
    t.date     "start_date",     default: '2017-03-31', null: false
    t.date     "end_date",       default: '2017-04-07', null: false
    t.integer  "state",          default: 0
    t.decimal  "objective"
    t.integer  "trainer_id"
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["name"], name: "index_challanges_on_name", using: :btree
    t.index ["trainer_id"], name: "index_challanges_on_trainer_id", using: :btree
    t.index ["user_id"], name: "index_challanges_on_user_id", using: :btree
  end

  create_table "diseases", force: :cascade do |t|
    t.string   "name",                     null: false
    t.text     "description", default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["name"], name: "index_diseases_on_name", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",                                        null: false
    t.text     "description", default: ""
    t.string   "otro_name",   default: "",                    null: false
    t.datetime "class_date",  default: '2017-04-01 01:27:42'
    t.decimal  "duration",    default: "1.0",                 null: false
    t.integer  "type_event",  default: 0
    t.text     "image"
    t.integer  "branch_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index ["branch_id"], name: "index_events_on_branch_id", using: :btree
    t.index ["name"], name: "index_events_on_name", using: :btree
  end

  create_table "exercises", force: :cascade do |t|
    t.string   "name",                           null: false
    t.text     "description",  default: ""
    t.text     "problems",     default: ""
    t.string   "benefits",     default: ""
    t.integer  "muscle_group",                   null: false
    t.text     "elements",     default: [],                   array: true
    t.string   "owner",        default: "admin", null: false
    t.integer  "trainer_id"
    t.integer  "level",        default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["name"], name: "index_exercises_on_name", using: :btree
    t.index ["owner"], name: "index_exercises_on_owner", using: :btree
    t.index ["trainer_id"], name: "index_exercises_on_trainer_id", using: :btree
  end

  create_table "food_day_per_foods", force: :cascade do |t|
    t.integer  "food_id"
    t.integer  "food_day_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["food_day_id"], name: "index_food_day_per_foods_on_food_day_id", using: :btree
    t.index ["food_id"], name: "index_food_day_per_foods_on_food_id", using: :btree
  end

  create_table "food_days", force: :cascade do |t|
    t.integer  "type_food",            default: 0,  null: false
    t.text     "description",          default: ""
    t.text     "benefits",             default: ""
    t.integer  "nutrition_routine_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["nutrition_routine_id"], name: "index_food_days_on_nutrition_routine_id", using: :btree
  end

  create_table "foods", force: :cascade do |t|
    t.string   "name",                          null: false
    t.text     "description",   default: ""
    t.decimal  "proteins",      default: "0.0", null: false
    t.decimal  "carbohydrates", default: "0.0", null: false
    t.decimal  "fats",          default: "0.0", null: false
    t.text     "image"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["name"], name: "index_foods_on_name", using: :btree
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
    t.string   "speciality",             default: [],                   array: true
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

  create_table "images", force: :cascade do |t|
    t.text     "description",    default: "", null: false
    t.text     "image"
    t.string   "imageable_type"
    t.integer  "imageable_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree
  end

  create_table "measurements", force: :cascade do |t|
    t.decimal  "weight",              default: "0.0", null: false
    t.decimal  "hips",                default: "0.0", null: false
    t.decimal  "chest",               default: "0.0", null: false
    t.decimal  "body_fat_percentage", default: "0.0", null: false
    t.decimal  "waist",               default: "0.0", null: false
    t.integer  "user_id"
    t.integer  "trainer_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["trainer_id"], name: "index_measurements_on_trainer_id", using: :btree
    t.index ["user_id"], name: "index_measurements_on_user_id", using: :btree
  end

  create_table "medical_record_by_diseases", force: :cascade do |t|
    t.integer  "medical_record_id"
    t.integer  "disease_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["disease_id"], name: "index_medical_record_by_diseases_on_disease_id", using: :btree
    t.index ["medical_record_id"], name: "index_medical_record_by_diseases_on_medical_record_id", using: :btree
  end

  create_table "medical_records", force: :cascade do |t|
    t.text     "observation",         default: ""
    t.decimal  "weight",                           null: false
    t.string   "medication",          default: "", null: false
    t.decimal  "body_fat_percentage",              null: false
    t.decimal  "waist",                            null: false
    t.decimal  "hips",                             null: false
    t.decimal  "chest",                            null: false
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["user_id"], name: "index_medical_records_on_user_id", unique: true, using: :btree
  end

  create_table "nutrition_routines", force: :cascade do |t|
    t.string   "name",                               null: false
    t.text     "description", default: ""
    t.text     "objective",   default: ""
    t.date     "start_date",  default: '2017-03-31', null: false
    t.date     "end_date",    default: '2017-04-07', null: false
    t.integer  "user_id"
    t.integer  "trainer_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["name"], name: "index_nutrition_routines_on_name", using: :btree
    t.index ["trainer_id"], name: "index_nutrition_routines_on_trainer_id", using: :btree
    t.index ["user_id"], name: "index_nutrition_routines_on_user_id", using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.string   "name",                               null: false
    t.date     "start_day",   default: '2017-04-03', null: false
    t.date     "end_day",                            null: false
    t.text     "description",                        null: false
    t.integer  "branch_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["branch_id"], name: "index_offers_on_branch_id", using: :btree
  end

  create_table "prohibited_exercises", force: :cascade do |t|
    t.integer  "exercise_id"
    t.integer  "medical_record_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["exercise_id"], name: "index_prohibited_exercises_on_exercise_id", using: :btree
    t.index ["medical_record_id"], name: "index_prohibited_exercises_on_medical_record_id", using: :btree
  end

  create_table "qualifications", force: :cascade do |t|
    t.text     "description",   default: "", null: false
    t.string   "name",                       null: false
    t.text     "qualification"
    t.integer  "trainer_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["name"], name: "index_qualifications_on_name", using: :btree
    t.index ["trainer_id"], name: "index_qualifications_on_trainer_id", using: :btree
  end

  create_table "routines", force: :cascade do |t|
    t.integer  "series",      default: 4
    t.integer  "repetition",  default: 12
    t.decimal  "time",        default: "0.0"
    t.decimal  "rest",        default: "5.0"
    t.integer  "level",                       null: false
    t.integer  "exercise_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["exercise_id"], name: "index_routines_on_exercise_id", using: :btree
  end

  create_table "timetables", force: :cascade do |t|
    t.date     "day",                        null: false
    t.string   "open_hour",                  null: false
    t.string   "close_hour",                 null: false
    t.boolean  "repeat",     default: true
    t.boolean  "closed",     default: false
    t.integer  "branch_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["branch_id"], name: "index_timetables_on_branch_id", using: :btree
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
    t.string   "mobile"
    t.string   "email"
    t.string   "speciality",             default: [],                   array: true
    t.integer  "type_trainer"
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
    t.string   "mobile"
    t.integer  "remaining_days",         default: 0,       null: false
    t.date     "birthday"
    t.integer  "gender"
    t.text     "objective"
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

  create_table "workout_per_day_per_exercises", force: :cascade do |t|
    t.integer  "workout_per_day_id"
    t.integer  "routine_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["routine_id"], name: "index_workout_per_day_per_exercises_on_routine_id", using: :btree
    t.index ["workout_per_day_id"], name: "index_workout_per_day_per_exercises_on_workout_per_day_id", using: :btree
  end

  create_table "workout_per_days", force: :cascade do |t|
    t.string   "name",                     null: false
    t.text     "description", default: ""
    t.text     "benefits",    default: ""
    t.integer  "level",       default: 0,  null: false
    t.integer  "order",       default: 0,  null: false
    t.integer  "workout_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["name"], name: "index_workout_per_days_on_name", using: :btree
    t.index ["order", "workout_id"], name: "index_workout_per_days_on_order_and_workout_id", unique: true, using: :btree
    t.index ["workout_id"], name: "index_workout_per_days_on_workout_id", using: :btree
  end

  create_table "workouts", force: :cascade do |t|
    t.string   "name",                               null: false
    t.text     "description", default: ""
    t.text     "objective",   default: ""
    t.date     "start_date",  default: '2017-03-31', null: false
    t.integer  "days",                               null: false
    t.date     "end_date",    default: '2017-04-07', null: false
    t.integer  "day",         default: 0
    t.integer  "level"
    t.integer  "trainer_id"
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["name"], name: "index_workouts_on_name", using: :btree
    t.index ["trainer_id"], name: "index_workouts_on_trainer_id", using: :btree
    t.index ["user_id"], name: "index_workouts_on_user_id", using: :btree
  end

  add_foreign_key "challanges", "trainers"
  add_foreign_key "challanges", "users"
  add_foreign_key "events", "branches"
  add_foreign_key "exercises", "trainers"
  add_foreign_key "food_day_per_foods", "food_days"
  add_foreign_key "food_day_per_foods", "foods"
  add_foreign_key "food_days", "nutrition_routines"
  add_foreign_key "measurements", "trainers"
  add_foreign_key "measurements", "users"
  add_foreign_key "medical_record_by_diseases", "diseases"
  add_foreign_key "medical_record_by_diseases", "medical_records"
  add_foreign_key "medical_records", "users"
  add_foreign_key "nutrition_routines", "trainers"
  add_foreign_key "nutrition_routines", "users"
  add_foreign_key "offers", "branches"
  add_foreign_key "prohibited_exercises", "exercises"
  add_foreign_key "prohibited_exercises", "medical_records"
  add_foreign_key "qualifications", "trainers"
  add_foreign_key "routines", "exercises"
  add_foreign_key "timetables", "branches"
  add_foreign_key "workout_per_day_per_exercises", "routines"
  add_foreign_key "workout_per_day_per_exercises", "workout_per_days"
  add_foreign_key "workout_per_days", "workouts"
  add_foreign_key "workouts", "trainers"
  add_foreign_key "workouts", "users"
end
