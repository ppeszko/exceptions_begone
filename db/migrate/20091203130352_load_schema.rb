class LoadSchema < ActiveRecord::Migration
  def self.up
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
      t.text     "payload",    :limit => 16777215,                :null => false
      t.integer  "status",                         :default => 0, :null => false
      t.integer  "stack_id",                                      :null => false
    end

    create_table "projects", :force => true do |t|
      t.string   "name"
      t.string   "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "warning_threshold", :default => 10
    end

    create_table "stacks", :force => true do |t|
      t.text     "identifier",  :limit => 16777215
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

  def self.down
    
  end
end
