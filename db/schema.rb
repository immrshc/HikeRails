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

ActiveRecord::Schema.define(version: 20151208140312) do

  create_table "Posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "text"
    t.float    "latitude"
    t.float    "longitude"
    t.binary   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ctype"
  end

  add_index "Posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "favorites", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "favorites", ["post_id"], name: "index_favorites_on_post_id"
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "replies", force: :cascade do |t|
    t.integer  "post_id"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "replies", ["post_id"], name: "index_replies_on_post_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "mail"
    t.string   "password"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "token"
  end

end
