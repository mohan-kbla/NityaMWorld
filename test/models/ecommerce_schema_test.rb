require "test_helper"

class EcommerceSchemaTest < ActiveSupport::TestCase
  # Helper to clean database tables manually if fixtures interfere
  setup do
    Wishlist.destroy_all
    Review.destroy_all
    OrderItem.destroy_all
    Order.destroy_all
    Product.destroy_all
    Category.destroy_all
    Brand.destroy_all
    User.destroy_all
    Address.destroy_all
    Coupon.destroy_all
  end

  test "user creation and role helpers" do
    user = User.new(
      email: "user@example.com",
      password: "password123",
      first_name: "John",
      last_name: "Doe",
      phone: "1234567890",
      role: "customer"
    )
    assert user.save
    assert user.customer?
    refute user.admin?
    refute user.staff?

    admin = User.new(
      email: "admin@example.com",
      password: "password123",
      first_name: "Admin",
      last_name: "User",
      phone: "0987654321",
      role: "admin"
    )
    assert admin.save
    assert admin.admin?
  end

  test "nested category associations" do
    parent = Category.create!(name: "Electronics")
    child = Category.create!(name: "Laptops", parent: parent)

    assert_equal parent, child.parent
    assert_includes parent.subcategories, child
  end

  test "product active price and validation rules" do
    category = Category.create!(name: "Apparel")
    brand = Brand.create!(name: "NityaBrand")

    product = Product.new(
      name: "T-Shirt",
      sku: "TSHIRT123",
      price: 500.00,
      stock: 10,
      category: category,
      brand: brand
    )
    assert product.save
    assert_equal 500.00, product.active_price
    refute product.discounted?

    # Apply discount
    product.discount_price = 400.00
    assert product.save
    assert_equal 400.00, product.active_price
    assert product.discounted?

    # Invalid discount price
    product.discount_price = 600.00
    refute product.save
    assert_includes product.errors[:discount_price], "must be less than the regular price"
  end

  test "coupon validity and calculations" do
    # Percent coupon
    coupon = Coupon.create!(
      code: "SAVE20",
      discount_type: "percentage",
      discount_value: 20.0,
      min_order_amount: 100.00,
      active: true
    )
    assert coupon.valid_for?(150.00)
    assert_equal 30.00, coupon.calculate_discount(150.00)

    # Expiry
    coupon.update!(expiry_date: 1.day.ago)
    refute coupon.valid_for?(150.00)
  end

  test "order address and item snapshots" do
    user = User.create!(email: "customer@example.com", password: "password123", first_name: "A", last_name: "B", phone: "1")
    category = Category.create!(name: "Food")
    brand = Brand.create!(name: "Homely")
    product = Product.create!(name: "Snack", sku: "SNACK1", price: 100.00, stock: 50, category: category, brand: brand)

    shipping = Address.create!(address_type: "shipping", full_name: "John S", address_line1: "Line 1", city: "C", state: "S", zip_code: "123", phone: "1")
    billing = Address.create!(address_type: "billing", full_name: "John B", address_line1: "Line 1", city: "C", state: "S", zip_code: "123", phone: "1")

    order = Order.new(
      user: user,
      status: "pending",
      payment_method: "cod",
      payment_status: "pending",
      shipping_address: shipping,
      billing_address: billing,
      subtotal_amount: 200.00,
      shipping_amount: 50.00,
      discount_amount: 10.00,
      total_amount: 240.00
    )
    assert order.save

    item = OrderItem.create!(
      order: order,
      product: product,
      quantity: 2,
      price: 100.00,
      total_price: 200.00
    )
    assert_includes order.order_items, item
  end

  test "product reviews rating average update hooks" do
    user1 = User.create!(email: "u1@example.com", password: "password", first_name: "U", last_name: "1", phone: "1")
    user2 = User.create!(email: "u2@example.com", password: "password", first_name: "U", last_name: "2", phone: "2")
    category = Category.create!(name: "Books")
    brand = Brand.create!(name: "Publishing")
    product = Product.create!(name: "Book", sku: "BOOK1", price: 300.00, stock: 10, category: category, brand: brand)

    assert_equal 0.0, product.rating

    # Add pending review - should not update rating average
    r1 = Review.create!(user: user1, product: product, rating: 5, title: "Great", body: "Cool book", status: "pending")
    product.reload
    assert_equal 0.0, product.rating

    # Approve review - updates average
    r1.update!(status: "approved")
    product.reload
    assert_equal 5.0, product.rating

    # Add and approve 2nd review
    r2 = Review.create!(user: user2, product: product, rating: 3, title: "Ok", body: "Decent book", status: "approved")
    product.reload
    assert_equal 4.0, product.rating # (5 + 3) / 2 = 4.0

    # Delete review
    r2.destroy
    product.reload
    assert_equal 5.0, product.rating
  end
end
