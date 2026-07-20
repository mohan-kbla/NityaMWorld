require "test_helper"

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = User.create!(email: "adm_test@example.com", password: "password123", role: "admin", first_name: "A", last_name: "B", phone: "1")
    @staff = User.create!(email: "stf_test@example.com", password: "password123", role: "staff", first_name: "S", last_name: "T", phone: "2")
    @customer = User.create!(email: "cust_test@example.com", password: "password123", role: "customer", first_name: "C", last_name: "D", phone: "3")

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

  test "admin can view orders index page" do
    sign_in @admin
    get admin_orders_path
    assert_response :success
  end

  test "staff can view orders index page" do
    sign_in @staff
    get admin_orders_path
    assert_response :success
  end

  test "customer cannot view orders index page" do
    sign_in @customer
    get admin_orders_path
    assert_redirected_to root_path
  end
end
