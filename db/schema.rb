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

ActiveRecord::Schema.define(version: 20150120071108) do

  create_table "addressbooks", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addressbooks", ["user_id"], name: "index_addressbooks_on_user_id"

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

  add_index "announcements", ["article_id"], name: "index_announcements_on_article_id"
  add_index "announcements", ["id", "type"], name: "index_announcements_on_id_and_type"

  create_table "articles", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banners", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "ranking",     default: 999,      null: false
    t.string   "status",      default: "enable"
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

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

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

  add_index "communities", ["article_id"], name: "index_communities_on_article_id"
  add_index "communities", ["id", "type"], name: "index_communities_on_id_and_type"

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "new"
  end

  create_table "daily_reports", force: true do |t|
    t.string   "name"
    t.integer  "total_order_count"
    t.integer  "onhold_order_count"
    t.integer  "valid_order_count"
    t.integer  "completed_order_count"
    t.integer  "cancel_order_count"
    t.integer  "abnormal_end_order_count"
    t.integer  "new_member_count"
    t.integer  "total_shipping_revenue"
    t.integer  "total_product_revenue"
    t.datetime "run_at"
    t.datetime "target_date"
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

  add_index "galleries", ["attachable_id", "attachable_type"], name: "index_galleries_on_attachable_id_and_attachable_type"
  add_index "galleries", ["id", "type"], name: "index_galleries_on_id_and_type"

  create_table "lookbook_topicships", force: true do |t|
    t.integer  "lookbook_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lookbook_topicships", ["lookbook_id"], name: "index_lookbook_topicships_on_lookbook_id"
  add_index "lookbook_topicships", ["topic_id"], name: "index_lookbook_topicships_on_topic_id"

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

  add_index "measurements", ["product_id"], name: "index_measurements_on_product_id"

  create_table "orderasks", force: true do |t|
    t.integer  "order_id"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orderasks", ["order_id"], name: "index_orderasks_on_order_id"

  create_table "orderitems", force: true do |t|
    t.integer  "order_id"
    t.string   "item_name"
    t.string   "item_stockname"
    t.integer  "item_price"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stock_id"
  end

  add_index "orderitems", ["order_id"], name: "index_orderitems_on_order_id"

  create_table "orderlogs", force: true do |t|
    t.integer  "order_id"
    t.string   "content"
    t.string   "inner_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orderlogs", ["order_id"], name: "index_orderlogs_on_order_id"

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
    t.string   "token"
    t.string   "payerid"
    t.date     "fillout_date"
    t.string   "invoice_address"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "photos", force: true do |t|
    t.string   "image"
    t.string   "name"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["article_id"], name: "index_photos_on_article_id"

  create_table "pickups", force: true do |t|
    t.string   "title"
    t.string   "description"
    t.integer  "product_id"
    t.integer  "ranking",     default: 999,      null: false
    t.string   "status",      default: "enable"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pickups", ["product_id"], name: "index_pickups_on_product_id"

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
    t.string   "product_no"
  end

  add_index "products", ["article_id"], name: "index_products_on_article_id"
  add_index "products", ["category_id"], name: "index_products_on_category_id"

  create_table "revenue_details", force: true do |t|
    t.integer  "context_id"
    t.string   "context_displayname"
    t.string   "category_name"
    t.string   "product_name"
    t.string   "stock_name"
    t.integer  "figure"
    t.string   "type"
    t.integer  "daily_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "revenue_details", ["daily_report_id"], name: "index_revenue_details_on_daily_report_id"

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], name: "index_roles_on_name"

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

  add_index "stocks", ["product_id"], name: "index_stocks_on_product_id"

  create_table "tiles", force: true do |t|
    t.integer  "lookbook_id"
    t.string   "context_1"
    t.string   "context_2"
    t.string   "context_3"
    t.string   "context_4"
    t.string   "context_5"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ranking",     default: 999
    t.integer  "topic_id"
  end

  add_index "tiles", ["lookbook_id"], name: "index_tiles_on_lookbook_id"
  add_index "tiles", ["topic_id"], name: "index_tiles_on_topic_id"

  create_table "topic_collection_topicships", force: true do |t|
    t.integer  "topic_collection_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topic_collection_topicships", ["topic_collection_id"], name: "index_topic_collection_topicships_on_topic_collection_id"
  add_index "topic_collection_topicships", ["topic_id"], name: "index_topic_collection_topicships_on_topic_id"

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

  add_index "topic_productships", ["product_id", "topic_id"], name: "index_topic_productships_on_product_id_and_topic_id"
  add_index "topic_productships", ["product_id"], name: "index_topic_productships_on_product_id"
  add_index "topic_productships", ["topic_id"], name: "index_topic_productships_on_topic_id"

  create_table "topics", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tracking_lists", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tracking_lists", ["product_id"], name: "index_tracking_lists_on_product_id"
  add_index "tracking_lists", ["user_id"], name: "index_tracking_lists_on_user_id"

  create_table "users", force: true do |t|
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
    t.string   "username"
    t.string   "tel"
    t.string   "address"
    t.string   "address_to_receive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthday"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"

end
