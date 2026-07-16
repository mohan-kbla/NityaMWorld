require "test_helper"

class AdminControllersTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = User.create!(
      email: "admin@example.com",
      password: "password123",
      first_name: "Admin",
      last_name: "User",
      phone: "111",
      role: "admin"
    )

    @staff = User.create!(
      email: "staff@example.com",
      password: "password123",
      first_name: "Staff",
      last_name: "User",
      phone: "222",
      role: "staff"
    )

    @customer = User.create!(
      email: "customer@example.com",
      password: "password123",
      first_name: "Cust",
      last_name: "User",
      phone: "333",
      role: "customer"
    )

    @category = Category.create!(name: "Test Cat")
    @brand = Brand.create!(name: "Test Brand")
    @product = Product.create!(
      name: "Test Prod",
      sku: "PROD1",
      price: 100.0,
      stock: 10,
      category: @category,
      brand: @brand
    )

    @shipping = Address.create!(address_type: "shipping", full_name: "S", address_line1: "L1", city: "C", state: "S", zip_code: "1", phone: "1")
    @billing = Address.create!(address_type: "billing", full_name: "B", address_line1: "L1", city: "C", state: "S", zip_code: "1", phone: "1")
    @order = Order.create!(
      user: @customer,
      status: "pending",
      payment_method: "cod",
      payment_status: "pending",
      shipping_address: @shipping,
      billing_address: @billing,
      subtotal_amount: 100.0,
      shipping_amount: 10.0,
      discount_amount: 0.0,
      total_amount: 110.0
    )
  end

  # --- ACCESS CONTROL TESTS ---

  test "guest user is redirected to login" do
    get admin_root_path
    assert_redirected_to new_user_session_path
  end

  test "customer user is redirected to root with authorization alert" do
    sign_in @customer
    get admin_root_path
    assert_redirected_to root_path
    assert_equal "You are not authorized to access the admin area.", flash[:alert]
  end

  test "staff user can access admin dashboard" do
    sign_in @staff
    get admin_root_path
    assert_response :success
  end

  test "admin user can access admin dashboard" do
    sign_in @admin
    get admin_root_path
    assert_response :success
  end

  # --- PRODUCTS CRUD TESTS ---

  test "staff user can create product but cannot delete it" do
    sign_in @staff

    # Get index
    get admin_products_path
    assert_response :success

    # Post create
    assert_difference("Product.count", 1) do
      post admin_products_path, params: {
        product: {
          name: "New Product",
          sku: "NEWPROD",
          price: 150.00,
          stock: 5,
          category_id: @category.id,
          brand_id: @brand.id
        }
      }
    end
    assert_redirected_to admin_product_path(Product.last)

    # Delete product - should be blocked by Pundit
    delete admin_product_path(@product)
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "admin user can delete product" do
    sign_in @admin
    assert_difference("Product.count", -1) do
      delete admin_product_path(@product)
    end
    assert_redirected_to admin_products_path
  end

  # --- ORDERS CONTROLLER TESTS ---

  test "staff user can cancel order but cannot refund it" do
    sign_in @staff

    # Show order
    get admin_order_path(@order)
    assert_response :success

    # Cancel order
    post cancel_admin_order_path(@order)
    assert_redirected_to admin_order_path(@order)
    @order.reload
    assert_equal "cancelled", @order.status

    # Refund order - should be blocked by Pundit
    post refund_admin_order_path(@order)
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "admin user can refund order" do
    sign_in @admin

    # Cancel first
    post cancel_admin_order_path(@order)

    # Refund order - should succeed
    post refund_admin_order_path(@order)
    assert_redirected_to admin_order_path(@order)
    @order.reload
    assert_equal "refunded", @order.status
  end
end
