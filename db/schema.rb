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

ActiveRecord::Schema.define(:version => 20100218094544) do

  create_table "exclusions", :force => true do |t|
    t.string   "name"
    t.boolean  "enabled"
    t.string   "pattern"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "payload",    :limit => 2147483647,                :null => false
    t.integer  "status",                           :default => 0, :null => false
    t.integer  "stack_id",                                        :null => false
    t.text     "identifier"
  end

  add_index "notifications", ["stack_id"], :name => "index_notifications_on_stack_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "warning_threshold", :default => 10
  end

  create_table "stacks", :force => true do |t|
    t.text     "identifier"
    t.integer  "project_id"
    t.integer  "status"
    t.integer  "notifications_count",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category",               :default => "",                    :null => false
    t.integer  "user_id"
    t.boolean  "email_sent",             :default => false,                 :null => false
    t.datetime "last_occurred_at",       :default => '2009-10-16 17:52:14', :null => false
    t.boolean  "threshold_warning_sent", :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "username",                          :null => false
    t.string   "email",                             :null => false
    t.string   "crypted_password",  :default => ""
    t.string   "password_salt",     :default => ""
    t.string   "persistence_token",                 :null => false
    t.integer  "login_count",       :default => 0,  :null => false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
