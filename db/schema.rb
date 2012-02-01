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

ActiveRecord::Schema.define(:version => 20120201201028) do

  create_table "articlemediacontents", :force => true do |t|
    t.integer  "article_id"
    t.integer  "mediafile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "excerpt"
    t.integer  "articletype"
    t.integer  "views"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "subtitles"
    t.integer  "section_id"
    t.string   "cleantitle"
    t.integer  "series_id"
  end

  create_table "attributions", :force => true do |t|
    t.integer  "person_id"
    t.integer  "mediafile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorships", :force => true do |t|
    t.integer  "person_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mediafiles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "mediatype"
    t.string   "media"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
  end

  create_table "people", :force => true do |t|
    t.string   "firstname"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "editor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "staff"
    t.string   "twitter"
    t.string   "lastname"
    t.string   "other_designation"
    t.string   "position"
    t.text     "bio"
    t.string   "profile"
    t.string   "clean_full_name"
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "clean_url"
  end

  create_table "series", :force => true do |t|
    t.text     "description"
    t.string   "logo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "stylebook_entries", :force => true do |t|
    t.text     "body"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
