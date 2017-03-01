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

ActiveRecord::Schema.define(version: 20170224025153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"

  create_table "article_endorsements", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_subscriptions", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_views", force: :cascade do |t|
    t.integer  "article_id",             null: false
    t.integer  "user_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "count",      default: 1
    t.index ["article_id", "user_id"], name: "index_article_views_on_article_id_and_user_id", unique: true, using: :btree
    t.index ["article_id"], name: "index_article_views_on_article_id", using: :btree
    t.index ["user_id"], name: "index_article_views_on_user_id", using: :btree
  end

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "editor_id"
    t.datetime "last_notified_author_at"
    t.datetime "archived_at"
    t.datetime "outdated_at"
    t.integer  "tags_count",               default: 0,     null: false
    t.boolean  "guide",                    default: false
    t.integer  "subscriptions_count",      default: 0
    t.integer  "endorsements_count",       default: 0
    t.integer  "visits",                   default: 0,     null: false
    t.integer  "outdatedness_reporter_id"
    t.index "to_tsvector('english'::regconfig, (title)::text)", name: "articles_title", using: :gin
    t.index "to_tsvector('english'::regconfig, content)", name: "articles_content", using: :gin
    t.index ["archived_at"], name: "index_articles_on_archived_at", using: :btree
    t.index ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  end

  create_table "articles_tags", force: :cascade do |t|
    t.integer "article_id"
    t.integer "tag_id"
    t.index ["article_id", "tag_id"], name: "index_articles_tags_on_article_id_and_tag_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.integer  "articles_count", default: 0, null: false
    t.index ["slug"], name: "index_tags_on_slug", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "avatar"
    t.boolean  "active",      default: true
    t.text     "shtick"
    t.json     "preferences"
  end

end
