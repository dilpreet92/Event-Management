# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141015135245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "username",           null: false
    t.string   "encrypted_password", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["username"], name: "index_admins_on_username", using: :btree

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "address"
    t.string   "city"
    t.string   "country"
    t.string   "contact_number"
    t.text     "description"
    t.boolean  "enable",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "rsvps", force: true do |t|
    t.integer  "user_id"
    t.integer  "session_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rsvps", ["user_id", "session_id"], name: "index_rsvps_on_user_id_and_session_id", unique: true, using: :btree

  create_table "sessions", force: true do |t|
    t.string   "topic"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.string   "speaker"
    t.boolean  "enable",      default: true
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "name"
    t.string   "access_token"
    t.string   "twitter_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "handle"
    t.boolean  "enable",         default: true
  end

end
