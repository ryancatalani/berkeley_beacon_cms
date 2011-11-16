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

ActiveRecord::Schema.define(:version => 20111116202134) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "excerpt"
    t.integer  "articletype"
    t.integer  "views"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "subtitles"
  end

  create_table "authorships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "editor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "staff"
  end

end
