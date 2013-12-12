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

ActiveRecord::Schema.define(:version => 20110102042324) do

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "subject"
    t.text     "content_html"
    t.text     "content_text"
    t.string   "from_name"
    t.string   "from_email"
    t.string   "attachment"
    t.string   "content_type", :default => "HTMLTEXT"
    t.integer  "status",       :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "content_id"
  end

  create_table "campaigns_categories", :id => false, :force => true do |t|
    t.integer "campaign_id"
    t.integer "category_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                                 :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 25
    t.string   "guid",              :limit => 10
    t.integer  "locale",            :limit => 2,  :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "fk_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_assetable_type"
  add_index "ckeditor_assets", ["user_id"], :name => "fk_user"

  create_table "comments", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "name"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "data"
    t.integer  "status",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "contacts_subscribers", :id => false, :force => true do |t|
    t.integer "contact_id"
    t.integer "subscriber_id"
  end

  create_table "contents", :force => true do |t|
    t.string   "name"
    t.text     "content_html"
    t.text     "content_text"
    t.integer  "status",       :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type", :default => "HTMLTEXT"
    t.integer  "user_id"
    t.datetime "published_at"
    t.string   "subject"
  end

  create_table "import_cells", :force => true do |t|
    t.integer  "import_table_id"
    t.integer  "row_index"
    t.integer  "column_index"
    t.string   "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_cells", ["import_table_id"], :name => "index_import_cells_on_import_table_id"

  create_table "import_tables", :force => true do |t|
    t.string   "original_path"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mailing_lists", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "data"
    t.integer  "status",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birthday"
    t.text     "bio"
    t.string   "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedulers", :force => true do |t|
    t.integer  "campaign_id"
    t.integer  "contact_id"
    t.integer  "content_id"
    t.integer  "supress_by"
    t.string   "priority",      :default => "normal"
    t.datetime "schedule_time"
    t.integer  "status",        :default => 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subscribers", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.integer  "status",     :default => 1
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "sex"
    t.datetime "dob"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
