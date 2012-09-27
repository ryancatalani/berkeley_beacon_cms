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

ActiveRecord::Schema.define(:version => 20120927181824) do

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
    t.boolean  "archive"
    t.text     "archive_images"
    t.boolean  "disable_comments"
    t.integer  "blog_id"
    t.boolean  "draft"
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

  create_table "blogs", :force => true do |t|
    t.text     "description"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cleantitle"
  end

  create_table "ecla_any_tweet", :force => true do |t|
    t.string   "tweet_id"
    t.string   "profile_image_url"
    t.string   "from_user"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ecla_any_tweet", ["tweet_id"], :name => "index_ecla_all_tweets_on_tweet_id"

  create_table "ecla_beacon_tweet", :force => true do |t|
    t.string   "tweet_id"
    t.string   "profile_image_url"
    t.string   "from_user"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ecla_beacon_tweet", ["tweet_id"], :name => "index_ecla_beacon_tweets_on_tweet_id"

  create_table "mediafiles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "mediatype"
    t.string   "media"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
    t.string   "video_mp4"
    t.string   "video_ogg"
    t.string   "video_webm"
    t.string   "direct_mp4_url"
    t.string   "direct_ogg_url"
    t.string   "direct_webm_url"
  end

  create_table "pastries", :force => true do |t|
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.boolean  "from_archive"
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
