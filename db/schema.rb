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

ActiveRecord::Schema.define(:version => 20121206020116) do

  create_table "drivers", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "encrypted_password",          :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "make"
    t.string   "model"
    t.integer  "year"
    t.string   "city"
    t.string   "state"
    t.string   "phone_number"
    t.string   "timeline_for_conversion"
    t.boolean  "interested_in_collaborating"
    t.text     "additional_comments"
    t.boolean  "wants_more_horsepower"
    t.boolean  "wants_replacement_battery"
    t.boolean  "wants_solar_driving"
    t.boolean  "wants_emergency_power"
    t.boolean  "wants_better_fuel_economy"
    t.boolean  "wants_improved_performance"
    t.integer  "zip"
  end

  add_index "drivers", ["confirmation_token"], :name => "index_drivers_on_confirmation_token", :unique => true
  add_index "drivers", ["email"], :name => "index_drivers_on_email", :unique => true
  add_index "drivers", ["reset_password_token"], :name => "index_drivers_on_reset_password_token", :unique => true

  create_table "earnests", :force => true do |t|
    t.integer  "driver_id"
    t.string   "model"
    t.integer  "year"
    t.string   "goal_complete_date"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "deposit"
    t.string   "options"
  end

  create_table "installers", :force => true do |t|
    t.string   "company_name"
    t.string   "contact_first_name"
    t.string   "contact_last_name"
    t.string   "contact_phone"
    t.text     "specialty_certificates"
    t.integer  "number_of_prius_customers"
    t.boolean  "worked_with_high_voltage_electronics"
    t.boolean  "worked_with_hybrid_systems"
    t.boolean  "electrician_certifications"
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.text     "additional_comments"
    t.string   "company_street"
    t.string   "company_city"
    t.string   "company_state"
    t.integer  "company_zipcode"
    t.boolean  "state_license"
    t.boolean  "want_additional_training"
  end

  add_index "installers", ["email"], :name => "index_installers_on_email", :unique => true
  add_index "installers", ["reset_password_token"], :name => "index_installers_on_reset_password_token", :unique => true

  create_table "payments", :force => true do |t|
    t.integer  "amount"
    t.integer  "driver_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "trans_id"
  end

  create_table "queries", :force => true do |t|
    t.string   "ar_query"
    t.string   "sql_query"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sales_leads", :force => true do |t|
    t.string   "user"
    t.string   "license_plate"
    t.string   "promotion_code"
    t.string   "address"
    t.string   "zipcode"
    t.float    "geolat"
    t.float    "geolng"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "notes"
    t.string   "promotion_type"
    t.string   "vehicle"
  end

end
