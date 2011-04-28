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

ActiveRecord::Schema.define(:version => 20110428024337) do

  create_table "comment_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comment_categories_entities", :force => true do |t|
    t.integer "comment_category_id"
    t.integer "entity_id"
    t.integer "counter"
    t.boolean "important_tag",       :default => false
  end

  add_index "comment_categories_entities", ["comment_category_id"], :name => "index_comment_categories_entities_on_comment_category_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "entity_id"
    t.integer  "category_id"
    t.string   "image_url"
    t.integer  "comment_id"
    t.string   "type"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "comments_counter", :default => 0
    t.boolean  "important_tag",    :default => false
  end

  create_table "comments_response_categories", :force => true do |t|
    t.integer "comment_id"
    t.integer "response_category_id"
    t.integer "counter"
    t.boolean "important_tag",          :default => false
    t.string  "response_category_name"
  end

  add_index "comments_response_categories", ["response_category_id"], :name => "index_comments_response_categories_on_response_category_id"

# Could not dump table "entities" because of following StandardError
#   Unknown type 'stirng' for column 'icon_name'

  create_table "icons", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "response_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resps", :force => true do |t|
    t.integer  "entity_id"
    t.string   "username"
    t.datetime "time"
    t.text     "resp"
    t.string   "lang"
    t.string   "image"
    t.string   "source"
    t.string   "location"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp_time_markers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                                                                           :null => false
    t.string   "email",                                                                                           :null => false
    t.string   "crypted_password",                                                                                :null => false
    t.string   "password_salt",                                                                                   :null => false
    t.string   "persistence_token",                                                                               :null => false
    t.string   "single_access_token",                                                                             :null => false
    t.string   "perishable_token",                                                                                :null => false
    t.integer  "login_count",         :default => 0,                                                              :null => false
    t.integer  "failed_login_count",  :default => 0,                                                              :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "current_entity_time", :default => '2010-10-08 07:59:46',                                          :null => false
    t.string   "user_image",          :default => "http://selfsolved.com/images/icons/default_user_icon_128.png"
  end

end
