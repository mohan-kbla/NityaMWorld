# Clear existing seed data safely
puts "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
Review.destroy_all
Wishlist.destroy_all
Product.destroy_all
Category.destroy_all
Brand.destroy_all
Coupon.destroy_all
Banner.destroy_all
Testimonial.destroy_all
BlogPost.destroy_all
Page.destroy_all
User.destroy_all

puts "Seeding NityaMWorld database (Bridal Jewellery & Hair Oils)..."

# 1. Users
admin = User.find_or_create_by!(email: "admin@nityamworld.com") do |u|
  u.password = "password123"
  u.first_name = "System"
  u.last_name = "Admin"
  u.phone = "9876543210"
  u.role = "admin"
end
puts "Created Admin: admin@nityamworld.com / password123"

staff = User.find_or_create_by!(email: "staff@nityamworld.com") do |u|
  u.password = "password123"
  u.first_name = "Store"
  u.last_name = "Operator"
  u.phone = "9876543211"
  u.role = "staff"
end
puts "Created Staff: staff@nityamworld.com / password123"

customer = User.find_or_create_by!(email: "customer@nityamworld.com") do |u|
  u.password = "password123"
  u.first_name = "John"
  u.last_name = "Customer"
  u.phone = "9876543212"
  u.role = "customer"
end
puts "Created Customer: customer@nityamworld.com / password123"

# 2. Categories
jewellery = Category.create!(name: "Bridal Jewellery", description: "Premium handcrafted bridal gold and silver heritage jewellery sets.")
jewellery.image.attach(io: File.open(Rails.root.join("db/seeds/images/category_jewellery.png")), filename: "category_jewellery.png", content_type: "image/png")

oils = Category.create!(name: "Hair Oils", description: "100% natural, premium herbal and wood-pressed hair oils.")
oils.image.attach(io: File.open(Rails.root.join("db/seeds/images/category_hair_oils.png")), filename: "category_hair_oils.png", content_type: "image/png")

# 3. Brands
brand_gold = Brand.create!(name: "Nitya Heritage", description: "Authentic traditional gold and silver designs.")
brand_oils = Brand.create!(name: "Nitya Organics", description: "Purity-guaranteed wood-pressed premium oils.")

# 4. Products (Jewellery)
p1 = Product.create!(
  name: "Royal Heritage Bridal Gold Necklace Set",
  sku: "JEWEL-BRD-GLD1",
  short_description: "Exquisite handcrafted traditional bridal gold neckpiece.",
  description: "Exquisitely crafted 22K gold bridal necklace set with rubies, emeralds, and pearls. Includes matching heavy drop earrings. Designed for royal wedding celebrations.",
  price: 95000.00,
  discount_price: 89000.00,
  stock: 2,
  featured: true,
  best_seller: true,
  category: jewellery,
  brand: brand_gold
)
# Attach premium image and sample video
p1.images.attach(io: File.open(Rails.root.join("db/seeds/images/bridal_jewellery.png")), filename: "bridal_jewellery.png", content_type: "image/png")
p1.images.attach(io: File.open(Rails.root.join("db/seeds/videos/sample_video.mp4")), filename: "sample_video.mp4", content_type: "video/mp4")

p2 = Product.create!(
  name: "Handcrafted Silver Filigree Jhumkas",
  sku: "JEWEL-SLV-JH2",
  short_description: "Stunning 92.5 sterling silver traditional earrings.",
  description: "Exquisitely designed sterling silver Jhumkas featuring delicate floral filigree patterns and dangling freshwater pearls, capturing timeless ethnic charm.",
  price: 4500.00,
  stock: 12,
  featured: true,
  category: jewellery,
  brand: brand_gold
)
p2.images.attach(io: File.open(Rails.root.join("db/seeds/images/silver_jhumkas.png")), filename: "silver_jhumkas.png", content_type: "image/png")
p2.images.attach(io: File.open(Rails.root.join("db/seeds/videos/sample_video.mp4")), filename: "sample_video.mp4", content_type: "video/mp4")

# Products (Hair Oils)
p3 = Product.create!(
  name: "Pure Amla & Hibiscus Herbal Hair Oil",
  sku: "OIL-HR-AMLA1",
  short_description: "100% pure organic herbal hair conditioning oil.",
  description: "Enriched with cold-pressed amla extracts, hibiscus flowers, and wood-pressed coconut oil base. Promotes hair thickness, controls scalp heat, and boosts shine.",
  price: 349.00,
  stock: 50,
  featured: true,
  best_seller: true,
  new_arrival: true,
  category: oils,
  brand: brand_oils
)
# Attach premium image and sample video
p3.images.attach(io: File.open(Rails.root.join("db/seeds/images/herbal_oil.png")), filename: "herbal_oil.png", content_type: "image/png")
p3.images.attach(io: File.open(Rails.root.join("db/seeds/videos/sample_video.mp4")), filename: "sample_video.mp4", content_type: "video/mp4")

p4 = Product.create!(
  name: "Premium Cold Pressed Almond Hair Oil",
  sku: "OIL-HR-ALM1",
  short_description: "Pure sweet almond oil for scalp nutrition.",
  description: "Extracted from sweet almonds using traditional wooden presses. Rich in Vitamin E, perfect for scalp hydration and hair root strength.",
  price: 499.00,
  stock: 20,
  featured: true,
  category: oils,
  brand: brand_oils
)
p4.images.attach(io: File.open(Rails.root.join("db/seeds/images/almond_oil.png")), filename: "almond_oil.png", content_type: "image/png")
p4.images.attach(io: File.open(Rails.root.join("db/seeds/videos/sample_video.mp4")), filename: "sample_video.mp4", content_type: "video/mp4")

# 5. Coupons
Coupon.create!(code: "WELCOME10", discount_type: "percentage", discount_value: 10.00, min_order_amount: 100.00, active: true)
Coupon.create!(code: "BRIDAL1000", discount_type: "flat", discount_value: 1000.00, min_order_amount: 10000.00, active: true)

# 6. Banners
b1 = Banner.create!(title: "Handcrafted Bridal Jewellery", subtitle: "Exquisite 22K gold & sterling silver heritage collections.", link_url: "/shop?q[category_id_eq]=#{jewellery.id}", active: true, position: 0)
b1.image.attach(io: File.open(Rails.root.join("db/seeds/images/banner_jewellery.png")), filename: "banner_jewellery.png", content_type: "image/png")

b2 = Banner.create!(title: "Pure Herbal Hair Oils", subtitle: "Traditional amla & neem extracts for deep root nutrition.", link_url: "/shop?q[category_id_eq]=#{oils.id}", active: true, position: 1)
b2.image.attach(io: File.open(Rails.root.join("db/seeds/images/banner_oil_1.png")), filename: "banner_oil_1.png", content_type: "image/png")

b3 = Banner.create!(title: "Natural Ayurveda Hair Growth", subtitle: "Wood-pressed oils rich in Vitamin E & essential nutrients.", link_url: "/shop?q[category_id_eq]=#{oils.id}", active: true, position: 2)
b3.image.attach(io: File.open(Rails.root.join("db/seeds/images/banner_oil_2.png")), filename: "banner_oil_2.png", content_type: "image/png")

# 7. Testimonials
Testimonial.create!(author_name: "Aishwarya R.", author_designation: "Verified Bride", content: "The bridal necklace set is absolutely stunning. The craftsmanship is flawless and looks very majestic.", rating: 5, active: true)
Testimonial.create!(author_name: "Dr. Srinivas", author_designation: "Dermatologist", content: "The amla hair oil has a wonderful calming effect and aroma. Purity guaranteed.", rating: 5, active: true)

# 8. Pages
Page.create!(title: "Privacy Policy", content: "This privacy policy explains how we collect and process customer transaction files and session details...", active: true)
Page.create!(title: "Terms & Conditions", content: "These terms govern purchases made through the NityaMWorld storefront catalog...", active: true)
Page.create!(title: "Shipping & Returns", content: "Standard delivery takes 3-5 business days. Returns accepted within 7 days of shipment...", active: true)

# 9. Blogs
BlogPost.create!(title: "How to Take Care of Bridal Gold Jewellery", content: "Bridal jewellery requires delicate maintenance. Wipe with a dry microfiber cloth and store in velvet lined airtight cases to maintain shine...", published_at: Time.current)

puts "Database seeding complete!"
