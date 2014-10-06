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

ActiveRecord::Schema.define(version: 20141006123542) do

  create_table "event_sessions", force: true do |t|
    t.string   "topic"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "location"
    t.string   "speaker"
    t.boolean  "status",      default: true
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.integer  "contact_number"
    t.text     "description"
    t.boolean  "status",         default: true
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "user_session_associations", force: true do |t|
    t.integer  "user_id"
    t.integer  "session_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "name"
    t.string   "access_token"
    t.string   "twitter_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "uid"
    t.string   "handle"
  end

end
