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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140708143221) do

  create_table "palette_sets", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "palette_sets", ["user_id"], name: "index_palette_sets_on_user_id"

  create_table "palettes", force: true do |t|
    t.text     "colors"
    t.text     "sources"
    t.text     "image_url"
    t.datetime "source_timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
