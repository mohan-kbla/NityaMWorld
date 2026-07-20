# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_15_161635) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "address_line1", null: false
    t.string "address_line2"
    t.string "address_type", null: false
    t.string "city", null: false
    t.string "country", default: "India", null: false
    t.datetime "created_at", null: false
    t.string "full_name", null: false
    t.string "phone", null: false
    t.string "state", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "zip_code", null: false
    t.index ["address_type"], name: "index_addresses_on_address_type"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "banners", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "link_url"
    t.integer "position", default: 0, null: false
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_banners_on_active"
    t.index ["position"], name: "index_banners_on_position"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.text "meta_description"
    t.string "meta_title"
    t.datetime "published_at"
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["published_at"], name: "index_blog_posts_on_published_at"
    t.index ["slug"], name: "index_blog_posts_on_slug", unique: true
  end

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name"
    t.index ["slug"], name: "index_brands_on_slug", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.text "meta_description"
    t.string "meta_title"
    t.string "name", null: false
    t.bigint "parent_id"
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "coupons", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.string "discount_type", null: false
    t.decimal "discount_value", precision: 10, scale: 2, null: false
    t.datetime "expiry_date"
    t.decimal "min_order_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.integer "usage_count", default: 0, null: false
    t.integer "usage_limit"
    t.index ["active"], name: "index_coupons_on_active"
    t.index ["code"], name: "index_coupons_on_code", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at"
    t.string "scope"
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "billing_address_id", null: false
    t.string "carrier"
    t.string "coupon_code"
    t.datetime "created_at", null: false
    t.decimal "discount_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.text "notes"
    t.string "payment_method", null: false
    t.string "payment_status", default: "pending", null: false
    t.string "razorpay_order_id"
    t.string "razorpay_payment_id"
    t.bigint "shipping_address_id", null: false
    t.decimal "shipping_amount", precision: 10, scale: 2, null: false
    t.string "status", default: "pending", null: false
    t.decimal "subtotal_amount", precision: 10, scale: 2, null: false
    t.decimal "total_amount", precision: 10, scale: 2, null: false
    t.string "tracking_number"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["razorpay_order_id"], name: "index_orders_on_razorpay_order_id"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.text "meta_description"
    t.string "meta_title"
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_pages_on_active"
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.boolean "best_seller", default: false, null: false
    t.integer "brand_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.decimal "discount_price", precision: 10, scale: 2
    t.boolean "featured", default: false, null: false
    t.text "meta_description"
    t.string "meta_title"
    t.string "name", null: false
    t.boolean "new_arrival", default: false, null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.decimal "rating", precision: 3, scale: 2, default: "0.0", null: false
    t.integer "reviews_count", default: 0, null: false
    t.text "short_description"
    t.string "sku", null: false
    t.string "slug", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 8, scale: 2
    t.index ["best_seller"], name: "index_products_on_best_seller"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["featured"], name: "index_products_on_featured"
    t.index ["new_arrival"], name: "index_products_on_new_arrival"
    t.index ["price"], name: "index_products_on_price"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.integer "rating", null: false
    t.string "status", default: "pending", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["status"], name: "index_reviews_on_status"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "testimonials", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "author_designation"
    t.string "author_name", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "rating", default: 5, null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_testimonials_on_active"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "customer", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "wishlists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "product_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["product_id"], name: "index_wishlists_on_product_id"
    t.index ["user_id", "product_id"], name: "index_wishlists_on_user_id_and_product_id", unique: true
    t.index ["user_id"], name: "index_wishlists_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "addresses", column: "billing_address_id"
  add_foreign_key "orders", "addresses", column: "shipping_address_id"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "categories"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "wishlists", "products"
  add_foreign_key "wishlists", "users"
end
