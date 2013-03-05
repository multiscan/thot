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

ActiveRecord::Schema.define(:version => 20130201133649) do

  create_table "books", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.string   "author"
    t.string   "editor"
    t.string   "call1",        :limit => 8
    t.string   "call2",        :limit => 16
    t.string   "call3",        :limit => 8
    t.string   "call4",        :limit => 8
    t.string   "collation"
    t.string   "isbn",         :limit => 24
    t.integer  "volume"
    t.string   "edition"
    t.integer  "publisher_id"
    t.string   "collection"
    t.string   "language",     :limit => 16
    t.string   "categories"
    t.text     "abstract"
    t.text     "toc"
    t.text     "idx"
    t.text     "notes"
    t.integer  "pubyear"
    t.float    "price"
    t.string   "currency",     :limit => 8
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "deg_isbns", :force => true do |t|
    t.string   "isbn"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "lab_id"
    t.integer  "location_id"
    t.integer  "inv"
    t.string   "status"
    t.float    "price"
    t.string   "currency"
    t.integer  "inventoriable_id"
    t.string   "inventoriable_type"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "labs", :force => true do |t|
    t.string   "name"
    t.string   "nick"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "loans", :force => true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.integer  "book_id"
    t.date     "return_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "operatorships", :force => true do |t|
    t.integer  "lab_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "searches", :force => true do |t|
    t.string   "query"
    t.string   "isbn"
    t.string   "publisher_name"
    t.string   "year_range"
    t.string   "inv_range"
    t.integer  "lab_id"
    t.integer  "location_id"
    t.string   "status"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                       :null => false
    t.string   "role",                   :default => "user", :null => false
    t.string   "location"
    t.string   "nebis"
    t.integer  "legacy_id"
    t.integer  "lab_id"
    t.datetime "expire_at"
    t.text     "notes"
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
