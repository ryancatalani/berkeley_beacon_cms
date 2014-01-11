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

ActiveRecord::Schema.define(:version => 20140111194620) do

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
    t.boolean  "link_only"
    t.string   "link"
    t.integer  "print_issue_id"
    t.integer  "issue_id"
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

  create_table "home_layouts", :force => true do |t|
    t.integer  "layout_type"
    t.text     "articles"
    t.text     "breaking_text"
    t.integer  "breaking_article"
    t.text     "custom_top_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", :force => true do |t|
    t.string   "pdf_url"
    t.date     "release_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pdf_thumb_url"
  end

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
    t.integer  "series_id"
    t.boolean  "horizontal",           :default => true, :null => false
    t.string   "direct_audio_mp3_url"
    t.string   "direct_audio_ogg_url"
  end

  create_table "pageviews", :force => true do |t|
    t.integer  "obj_pageviews_id"
    t.string   "encoded_ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "obj_pageviews_type"
  end

  add_index "pageviews", ["encoded_ip_address"], :name => "index_pageviews_on_encoded_ip_address"
  add_index "pageviews", ["obj_pageviews_id"], :name => "index_pageviews_on_obj_pageviews_id"

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
    t.string   "profile_video_mp4_url"
    t.string   "profile_video_ogg_url"
    t.string   "profile_video_webm_url"
  end

  create_table "political_poll_entries", :force => true do |t|
    t.integer  "q1"
    t.integer  "q2"
    t.integer  "q3"
    t.integer  "q4"
    t.integer  "q5"
    t.integer  "q6"
    t.integer  "q7"
    t.integer  "q8"
    t.integer  "q9"
    t.integer  "q10"
    t.integer  "q11"
    t.integer  "q12"
    t.integer  "q13"
    t.integer  "q14"
    t.integer  "q15"
    t.integer  "q16"
    t.integer  "q17"
    t.integer  "q18"
    t.integer  "q19"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ip_digest"
    t.integer  "start_time"
    t.integer  "end_time"
    t.boolean  "already_completed"
    t.string   "q8_other"
    t.integer  "q20"
    t.string   "confirmation"
    t.boolean  "confirmed"
    t.string   "email_hash"
  end

  create_table "popular_snapshots", :force => true do |t|
    t.text     "most_viewed"
    t.text     "most_shared"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "print_issues", :force => true do |t|
    t.datetime "publication_date"
    t.string   "pdf"
    t.string   "front_page_photo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "print_issues", ["publication_date"], :name => "index_print_issues_on_publication_date"

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

  create_table "short_links", :force => true do |t|
    t.string   "prefix"
    t.string   "link_text"
    t.string   "destination"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "short_links", ["link_text"], :name => "index_short_links_on_link_text"

  create_table "social_posts", :force => true do |t|
    t.text     "status_text"
    t.integer  "network"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id"
    t.datetime "post_time"
    t.boolean  "posted"
    t.boolean  "in_queue"
  end

  add_index "social_posts", ["network"], :name => "index_social_posts_on_network"

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

  create_table "topicals", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "topics", ["slug"], :name => "index_topics_on_slug"

end
