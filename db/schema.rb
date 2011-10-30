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

ActiveRecord::Schema.define(:version => 20111030211100) do

  create_table "backlog_items", :force => true do |t|
    t.integer  "backlog_id"
    t.string   "title"
    t.integer  "points"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "display_id"
    t.integer  "sprint_id"
  end

  add_index "backlog_items", ["backlog_id"], :name => "index_backlog_items_on_backlog_id"
  add_index "backlog_items", ["sprint_id"], :name => "index_backlog_items_on_sprint_id"

  create_table "backlogs", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "private",                      :default => false
    t.integer  "backlog_item_next_display_id"
  end

  add_index "backlogs", ["user_id"], :name => "index_backlogs_on_user_id"

  create_table "collaborators", :force => true do |t|
    t.integer  "user_id"
    t.integer  "backlog_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collaborators", ["backlog_id"], :name => "index_collaborators_on_backlog_id"
  add_index "collaborators", ["user_id"], :name => "index_collaborators_on_user_id"

  create_table "sprints", :force => true do |t|
    t.integer  "backlog_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start"
    t.datetime "stop"
  end

  add_index "sprints", ["backlog_id"], :name => "index_sprints_on_backlog_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
