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

ActiveRecord::Schema.define(:version => 20110703232559) do

  create_table "avatars", :force => true do |t|
    t.string   "caption"
    t.integer  "location_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "balance_histories", :force => true do |t|
    t.integer  "user_id"
    t.string   "confirmation_number"
    t.date     "payment_date"
    t.float    "recent_balance"
    t.float    "seller_total"
    t.float    "withdrawal_amount"
    t.float    "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "commissions", :force => true do |t|
    t.float    "buyer"
    t.float    "seller"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features_locations", :id => false, :force => true do |t|
    t.integer "feature_id"
    t.integer "location_id"
  end

  create_table "fee_structures", :force => true do |t|
    t.float    "park_buyer"
    t.float    "park_seller"
    t.float    "store_buyer"
    t.float    "store_seller"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.string   "location_status"
    t.integer  "user_id"
    t.string   "unit"
    t.string   "phone"
    t.string   "storage_type"
    t.string   "accommodates"
    t.string   "floor"
    t.string   "access"
    t.string   "security"
    t.string   "headline"
    t.text     "description"
    t.date     "start_date"
    t.string   "park_store"
    t.float    "price"
    t.string   "country_code"
    t.string   "county"
    t.string   "region"
    t.string   "city"
    t.string   "zipcode"
    t.string   "street"
    t.decimal  "latitude",        :precision => 15, :scale => 10
    t.decimal  "longitude",       :precision => 15, :scale => 10
    t.integer  "locatable_id"
    t.string   "locatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rent_status",                                     :default => "Available"
    t.string   "street_name"
    t.string   "street_number"
    t.string   "apartment"
    t.string   "nearest_metro"
  end

  create_table "payments", :force => true do |t|
    t.integer  "location_id"
    t.integer  "user_id"
    t.float    "amount"
    t.string   "name"
    t.string   "email"
    t.string   "cc_number"
    t.string   "billing_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "expire_month"
    t.string   "expire_year"
    t.string   "security_code"
    t.string   "phone_number"
    t.string   "hear_about_us"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rental_histories", :force => true do |t|
    t.integer  "location_id"
    t.integer  "creator_id"
    t.integer  "renter_id"
    t.date     "rent_date"
    t.date     "end_date"
    t.date     "payment_date"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requested_cities", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "transactions", :force => true do |t|
    t.string   "confirmation_number"
    t.integer  "location_id"
    t.float    "price"
    t.string   "list_type"
    t.float    "buyer_fee"
    t.float    "seller_fee"
    t.float    "buyer_total"
    t.float    "seller_total"
    t.float    "storably_total"
    t.date     "rent_date"
    t.date     "payment_date"
    t.integer  "creator_id"
    t.integer  "renter_id"
    t.integer  "withdrawer"
    t.float    "withdrawal_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.boolean  "active",              :default => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zip_code"
    t.string   "phone_number"
    t.string   "occupation"
    t.string   "school_attended"
    t.string   "share"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "photo_file_size"
    t.string   "city"
    t.integer  "renter_id"
    t.date     "rent_date"
    t.float    "recent_balance",      :default => 0.0
  end

end
