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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131110232053) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "plays", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shares", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "city"
    t.text     "bio"
    t.string   "slug"
    t.string   "avatar"
    t.boolean  "admin",                  :default => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.datetime "date_of_birth"
    t.string   "phone"
    t.string   "zipcode"
    t.string   "street"
    t.string   "state"
    t.integer  "plays_count",            :default => 0,     :null => false
    t.integer  "shares_count",           :default => 0,     :null => false
    t.integer  "votes_count",            :default => 0,     :null => false
    t.integer  "videos_count",           :default => 0,     :null => false
  end

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "category_id"
    t.boolean  "approved",        :default => false
    t.float    "length"
    t.integer  "plays_count",     :default => 0,     :null => false
    t.integer  "shares_count",    :default => 0,     :null => false
    t.integer  "votes_count",     :default => 0,     :null => false
    t.string   "title"
    t.string   "panda_video_id"
    t.float    "ave_vote",        :default => 0.0
    t.float    "rating"
    t.integer  "plays_quartile"
    t.integer  "shares_quartile"
    t.integer  "votes_quartile"
  end

  create_table "votes", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
