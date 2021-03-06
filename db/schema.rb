# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081209064535) do

  create_table "checkins", :force => true do |t|
    t.integer  "user_id",     :limit => 11
    t.integer  "project_id",  :limit => 11
    t.datetime "commit_time"
    t.string   "comment"
    t.string   "hashcode"
    t.string   "title"
    t.string   "url"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "days", :force => true do |t|
    t.integer  "user_id",        :limit => 11
    t.date     "date"
    t.integer  "commit_count",   :limit => 11
    t.integer  "current_streak", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feed_specs", :force => true do |t|
    t.string   "uri"
    t.string   "regex"
    t.string   "time_field_name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.integer  "user_id",      :limit => 11
    t.integer  "feed_spec_id", :limit => 11
    t.string   "login"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "streak",     :limit => 11
    t.integer  "max_streak", :limit => 11
    t.integer  "user_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "github_login"
    t.datetime "github_current_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
