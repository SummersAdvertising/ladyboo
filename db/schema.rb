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

ActiveRecord::Schema.define(version: 20141013040615) do

  create_table "addressbooks", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  add_index "admins", ["unlock_token"], name: "index_admins_on_unlock_token", unique: true

  create_table "announcements", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.integer  "ranking",    default: 999, null: false
    t.string   "status"
    t.integer  "article_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "ck_context"
  end

  create_table "articles", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banners", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "ranking",     default: 999, null: false
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type"

  create_table "communities", force: true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "ck_context"
    t.integer  "ranking",    default: 999, null: false
    t.string   "status"
    t.integer  "article_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deliveries", force: true do |t|
    t.string   "name"
    t.string   "tracking_url"
    t.integer  "normal_fee",         default: 600
    t.integer  "discount_fee",       default: 0
    t.integer  "discount_criteria",  default: 6000
    t.string   "iscod"
    t.string   "shipping_condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", force: true do |t|
    t.string   "file_name"
    t.string   "content_type"
    t.string   "file_size"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.string   "attachment"
    t.string   "type"
    t.integer  "ranking",         default: 999, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lookbook_topicships", force: true do |t|
    t.integer  "lookbook_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lookbooks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "disable"
    t.integer  "limit",      default: 1
  end

  create_table "measurements", force: true do |t|
    t.integer  "product_id"
    t.string   "title"
    t.string   "context_1"
    t.string   "context_2"
    t.string   "context_3"
    t.string   "context_4"
    t.string   "context_5"
    t.string   "context_6"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "orderasks", force: true do |t|
    t.integer  "order_id"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orderitems", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_stock_id"
    t.string   "item_name"
    t.string   "item_stockname"
    t.integer  "item_price"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orderlogs", force: true do |t|
    t.integer  "order_id"
    t.string   "content"
    t.string   "inner_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.string   "ordernum"
    t.string   "buyer_name"
    t.string   "buyer_tel"
    t.string   "receiver_name"
    t.string   "receiver_tel"
    t.string   "receiver_address"
    t.string   "payment_type"
    t.string   "payment_status"
    t.string   "invoice_type"
    t.string   "invoice_companynum"
    t.string   "invoice_title"
    t.string   "aasm_state",          default: "hold"
    t.string   "delivery_type"
    t.string   "package_tracking_no"
    t.text     "order_memo"
    t.text     "human_involved_memo"
    t.string   "accountinfo"
    t.integer  "items_total"
    t.integer  "shipping_fee"
    t.string   "ship_to"
    t.string   "shipped",             default: "no"
    t.string   "paid",                default: "no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.string   "image"
    t.string   "name"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pickups", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "product_id"
    t.integer  "ranking",     default: 999, null: false
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.integer  "price"
    t.integer  "price_for_sale"
    t.string   "status"
    t.integer  "article_id"
    t.text     "ck_context"
    t.integer  "ranking",        default: 999, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "en_name"
    t.text     "material"
    t.text     "wash"
    t.text     "model"
    t.string   "highlight"
    t.string   "is_new"
  end

  create_table "stocks", force: true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.string   "description_1"
    t.string   "description_2"
    t.integer  "amount"
    t.boolean  "assign_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_collection_topicships", force: true do |t|
    t.integer  "topic_collection_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topic_collections", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "disable"
    t.integer  "limit",      default: 1
  end

  create_table "topic_productships", force: true do |t|
    t.integer  "topic_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
