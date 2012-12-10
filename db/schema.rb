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

ActiveRecord::Schema.define(:version => 20121210220301) do

  create_table "achievements", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "url"
    t.text     "description"
    t.string   "image_url"
    t.integer  "points"
    t.text     "rule"
    t.integer  "position"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "achievementusers", :force => true do |t|
    t.integer  "achievement_id"
    t.integer  "track_id"
    t.integer  "trackuser_id"
    t.integer  "user_id"
    t.string   "meet_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "horse_id"
    t.decimal  "amount"
    t.string   "bet_type"
    t.integer  "meet_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "race_id"
    t.string   "status"
    t.integer  "track_id"
  end

  create_table "cards", :force => true do |t|
    t.string   "name"
    t.integer  "meet_id"
    t.text     "description"
    t.boolean  "completed"
    t.datetime "completed_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "status"
    t.integer  "initial_credits"
    t.integer  "track_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meet_id"
    t.integer  "race_id"
    t.integer  "card_id"
    t.integer  "track_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "credits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meet_id"
    t.decimal  "amount"
    t.text     "description"
    t.string   "credit_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "status"
    t.integer  "card_id"
    t.integer  "track_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "horses", :force => true do |t|
    t.string   "name"
    t.integer  "race_id"
    t.text     "description"
    t.integer  "finish"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "status"
    t.integer  "track_id"
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status"
    t.integer  "owner_id"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "leagueusers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "league_id"
    t.string   "status"
    t.string   "nickname"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "meetleagues", :force => true do |t|
    t.integer  "meet_id"
    t.integer  "league_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "meets", :force => true do |t|
    t.string   "name"
    t.integer  "track_id"
    t.text     "description"
    t.boolean  "completed"
    t.datetime "completed_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "status"
    t.integer  "initial_credits"
  end

  create_table "pusher_channels", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "races", :force => true do |t|
    t.string   "name"
    t.integer  "card_id"
    t.datetime "start_betting_time"
    t.datetime "post_time"
    t.text     "description"
    t.boolean  "completed"
    t.datetime "completed_date"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "status"
    t.integer  "track_id"
  end

  create_table "rankings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meet_id"
    t.decimal  "amount"
    t.string   "rank"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "card_id"
    t.integer  "track_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "trackleagues", :force => true do |t|
    t.integer  "league_id"
    t.integer  "track_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.boolean  "public"
    t.text     "description"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "status"
    t.string   "track_alias"
    t.string   "meet_alias"
    t.string   "card_alias"
    t.string   "race_alias"
    t.string   "horse_alias"
    t.string   "credit_alias"
    t.string   "member_alias"
    t.string   "bet_alias"
  end

  create_table "trackusers", :force => true do |t|
    t.integer  "track_id"
    t.integer  "user_id"
    t.string   "role"
    t.boolean  "allow_comments"
    t.string   "nickname"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "status"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "name"
    t.string   "time_zone"
    t.string   "status"
    t.string   "avatar"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
