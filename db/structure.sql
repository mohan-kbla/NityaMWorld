CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "friendly_id_slugs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "slug" varchar NOT NULL, "sluggable_id" integer NOT NULL, "sluggable_type" varchar(50), "scope" varchar, "created_at" datetime(6));
CREATE INDEX "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id" ON "friendly_id_slugs" ("sluggable_type", "sluggable_id") /*application='Nityamworld'*/;
CREATE INDEX "index_friendly_id_slugs_on_slug_and_sluggable_type" ON "friendly_id_slugs" ("slug", "sluggable_type") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope" ON "friendly_id_slugs" ("slug", "sluggable_type", "scope") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime(6), "remember_created_at" datetime(6), "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime(6), "last_sign_in_at" datetime(6), "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "first_name" varchar, "last_name" varchar, "phone" varchar, "role" varchar DEFAULT 'customer' NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token") /*application='Nityamworld'*/;
CREATE INDEX "index_users_on_role" ON "users" ("role") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "categories" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "slug" varchar NOT NULL, "description" text, "parent_id" bigint, "meta_title" varchar, "meta_description" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_82f48f7407"
FOREIGN KEY ("parent_id")
  REFERENCES "categories" ("id")
);
CREATE INDEX "index_categories_on_name" ON "categories" ("name") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_categories_on_slug" ON "categories" ("slug") /*application='Nityamworld'*/;
CREATE INDEX "index_categories_on_parent_id" ON "categories" ("parent_id") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "brands" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "slug" varchar NOT NULL, "description" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_brands_on_name" ON "brands" ("name") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_brands_on_slug" ON "brands" ("slug") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "products" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "slug" varchar NOT NULL, "sku" varchar NOT NULL, "description" text, "short_description" text, "price" decimal(10,2) NOT NULL, "discount_price" decimal(10,2), "stock" integer DEFAULT 0 NOT NULL, "weight" decimal(8,2), "featured" boolean DEFAULT FALSE NOT NULL, "best_seller" boolean DEFAULT FALSE NOT NULL, "new_arrival" boolean DEFAULT FALSE NOT NULL, "rating" decimal(3,2) DEFAULT 0.0 NOT NULL, "reviews_count" integer DEFAULT 0 NOT NULL, "category_id" integer NOT NULL, "brand_id" integer NOT NULL, "meta_title" varchar, "meta_description" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_fb915499a4"
FOREIGN KEY ("category_id")
  REFERENCES "categories" ("id")
, CONSTRAINT "fk_rails_f3b4d49caa"
FOREIGN KEY ("brand_id")
  REFERENCES "brands" ("id")
);
CREATE INDEX "index_products_on_category_id" ON "products" ("category_id") /*application='Nityamworld'*/;
CREATE INDEX "index_products_on_brand_id" ON "products" ("brand_id") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_products_on_slug" ON "products" ("slug") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_products_on_sku" ON "products" ("sku") /*application='Nityamworld'*/;
CREATE INDEX "index_products_on_price" ON "products" ("price") /*application='Nityamworld'*/;
CREATE INDEX "index_products_on_featured" ON "products" ("featured") /*application='Nityamworld'*/;
CREATE INDEX "index_products_on_best_seller" ON "products" ("best_seller") /*application='Nityamworld'*/;
CREATE INDEX "index_products_on_new_arrival" ON "products" ("new_arrival") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "addresses" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" bigint, "address_type" varchar NOT NULL, "full_name" varchar NOT NULL, "address_line1" varchar NOT NULL, "address_line2" varchar, "city" varchar NOT NULL, "state" varchar NOT NULL, "zip_code" varchar NOT NULL, "country" varchar DEFAULT 'India' NOT NULL, "phone" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_48c9e0c5a2"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_addresses_on_user_id" ON "addresses" ("user_id") /*application='Nityamworld'*/;
CREATE INDEX "index_addresses_on_address_type" ON "addresses" ("address_type") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "coupons" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "code" varchar NOT NULL, "discount_type" varchar NOT NULL, "discount_value" decimal(10,2) NOT NULL, "expiry_date" datetime(6), "usage_limit" integer, "usage_count" integer DEFAULT 0 NOT NULL, "min_order_amount" decimal(10,2) DEFAULT 0.0 NOT NULL, "active" boolean DEFAULT TRUE NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_coupons_on_code" ON "coupons" ("code") /*application='Nityamworld'*/;
CREATE INDEX "index_coupons_on_active" ON "coupons" ("active") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "orders" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "status" varchar DEFAULT 'pending' NOT NULL, "subtotal_amount" decimal(10,2) NOT NULL, "shipping_amount" decimal(10,2) NOT NULL, "discount_amount" decimal(10,2) DEFAULT 0.0 NOT NULL, "total_amount" decimal(10,2) NOT NULL, "coupon_code" varchar, "payment_method" varchar NOT NULL, "payment_status" varchar DEFAULT 'pending' NOT NULL, "razorpay_order_id" varchar, "razorpay_payment_id" varchar, "shipping_address_id" bigint NOT NULL, "billing_address_id" bigint NOT NULL, "tracking_number" varchar, "carrier" varchar, "notes" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_267c198c1b"
FOREIGN KEY ("shipping_address_id")
  REFERENCES "addresses" ("id")
, CONSTRAINT "fk_rails_f868b47f6a"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
, CONSTRAINT "fk_rails_b7a8fe49ff"
FOREIGN KEY ("billing_address_id")
  REFERENCES "addresses" ("id")
);
CREATE INDEX "index_orders_on_user_id" ON "orders" ("user_id") /*application='Nityamworld'*/;
CREATE INDEX "index_orders_on_status" ON "orders" ("status") /*application='Nityamworld'*/;
CREATE INDEX "index_orders_on_razorpay_order_id" ON "orders" ("razorpay_order_id") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "order_items" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "order_id" integer NOT NULL, "product_id" integer NOT NULL, "quantity" integer DEFAULT 1 NOT NULL, "price" decimal(10,2) NOT NULL, "total_price" decimal(10,2) NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_e3cb28f071"
FOREIGN KEY ("order_id")
  REFERENCES "orders" ("id")
, CONSTRAINT "fk_rails_f1a29ddd47"
FOREIGN KEY ("product_id")
  REFERENCES "products" ("id")
);
CREATE INDEX "index_order_items_on_order_id" ON "order_items" ("order_id") /*application='Nityamworld'*/;
CREATE INDEX "index_order_items_on_product_id" ON "order_items" ("product_id") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "reviews" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "product_id" integer NOT NULL, "rating" integer NOT NULL, "title" varchar, "body" text, "status" varchar DEFAULT 'pending' NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_74a66bd6c5"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
, CONSTRAINT "fk_rails_bedd9094d4"
FOREIGN KEY ("product_id")
  REFERENCES "products" ("id")
);
CREATE INDEX "index_reviews_on_user_id" ON "reviews" ("user_id") /*application='Nityamworld'*/;
CREATE INDEX "index_reviews_on_product_id" ON "reviews" ("product_id") /*application='Nityamworld'*/;
CREATE INDEX "index_reviews_on_rating" ON "reviews" ("rating") /*application='Nityamworld'*/;
CREATE INDEX "index_reviews_on_status" ON "reviews" ("status") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "wishlists" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "product_id" integer NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_eb66139660"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
, CONSTRAINT "fk_rails_4224d8f53b"
FOREIGN KEY ("product_id")
  REFERENCES "products" ("id")
);
CREATE INDEX "index_wishlists_on_user_id" ON "wishlists" ("user_id") /*application='Nityamworld'*/;
CREATE INDEX "index_wishlists_on_product_id" ON "wishlists" ("product_id") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_wishlists_on_user_id_and_product_id" ON "wishlists" ("user_id", "product_id") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "banners" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "subtitle" varchar, "link_url" varchar, "active" boolean DEFAULT TRUE NOT NULL, "position" integer DEFAULT 0 NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_banners_on_active" ON "banners" ("active") /*application='Nityamworld'*/;
CREATE INDEX "index_banners_on_position" ON "banners" ("position") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "testimonials" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "author_name" varchar NOT NULL, "author_designation" varchar, "content" text NOT NULL, "rating" integer DEFAULT 5 NOT NULL, "active" boolean DEFAULT TRUE NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE INDEX "index_testimonials_on_active" ON "testimonials" ("active") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "blog_posts" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar NOT NULL, "slug" varchar NOT NULL, "content" text NOT NULL, "meta_title" varchar, "meta_description" text, "published_at" datetime(6), "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_blog_posts_on_slug" ON "blog_posts" ("slug") /*application='Nityamworld'*/;
CREATE INDEX "index_blog_posts_on_published_at" ON "blog_posts" ("published_at") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "pages" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar NOT NULL, "slug" varchar NOT NULL, "content" text NOT NULL, "meta_title" varchar, "meta_description" text, "active" boolean DEFAULT TRUE NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_pages_on_slug" ON "pages" ("slug") /*application='Nityamworld'*/;
CREATE INDEX "index_pages_on_active" ON "pages" ("active") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "active_storage_blobs" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "key" varchar NOT NULL, "filename" varchar NOT NULL, "content_type" varchar, "metadata" text, "service_name" varchar NOT NULL, "byte_size" bigint NOT NULL, "checksum" varchar, "created_at" datetime(6) NOT NULL);
CREATE UNIQUE INDEX "index_active_storage_blobs_on_key" ON "active_storage_blobs" ("key") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "active_storage_attachments" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "record_type" varchar NOT NULL, "record_id" bigint NOT NULL, "blob_id" bigint NOT NULL, "created_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_c3b3935057"
FOREIGN KEY ("blob_id")
  REFERENCES "active_storage_blobs" ("id")
);
CREATE INDEX "index_active_storage_attachments_on_blob_id" ON "active_storage_attachments" ("blob_id") /*application='Nityamworld'*/;
CREATE UNIQUE INDEX "index_active_storage_attachments_uniqueness" ON "active_storage_attachments" ("record_type", "record_id", "name", "blob_id") /*application='Nityamworld'*/;
CREATE TABLE IF NOT EXISTS "active_storage_variant_records" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "blob_id" bigint NOT NULL, "variation_digest" varchar NOT NULL, CONSTRAINT "fk_rails_993965df05"
FOREIGN KEY ("blob_id")
  REFERENCES "active_storage_blobs" ("id")
);
CREATE UNIQUE INDEX "index_active_storage_variant_records_uniqueness" ON "active_storage_variant_records" ("blob_id", "variation_digest") /*application='Nityamworld'*/;
INSERT INTO "schema_migrations" (version) VALUES
('20260715161635'),
('20260715154314'),
('20260715154313'),
('20260715154312'),
('20260715154311'),
('20260715154310'),
('20260715154309'),
('20260715154308'),
('20260715154307'),
('20260715154306'),
('20260715154305'),
('20260715154304'),
('20260715154303'),
('20260715154302'),
('20260715154301'),
('20260715154300');

