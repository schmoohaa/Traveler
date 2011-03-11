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

ActiveRecord::Schema.define(:version => 20110311192908) do

  create_table "locales", :force => true do |t|
    t.string   "name"
    t.decimal  "lat",        :precision => 10, :scale => 6
    t.decimal  "lng",        :precision => 10, :scale => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trip_segments", :force => true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "mode_of_transport"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "distance_in_miles",     :default => 0
    t.integer  "trip_id"
    t.integer  "locale_origin_id"
    t.integer  "locale_destination_id"
  end

  create_table "trips", :force => true do |t|
    t.string   "name"
    t.string   "who"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
