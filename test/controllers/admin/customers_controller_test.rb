require "test_helper"

class Admin::CustomersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = User.create!(email: "admin_cust@example.com", password: "password123", role: "admin", first_name: "Admin", last_name: "User", phone: "123")
    @staff = User.create!(email: "staff_cust@example.com", password: "password123", role: "staff", first_name: "Staff", last_name: "User", phone: "456")
    @customer = User.create!(email: "buyer_cust@example.com", password: "password123", role: "customer", first_name: "Buyer", last_name: "User", phone: "789")
  end

  test "admin can view customers index page" do
    sign_in @admin
    get admin_customers_path
    assert_response :success
  end

  test "staff can view customers index page" do
    sign_in @staff
    get admin_customers_path
    assert_response :success
  end

  test "admin can view customer details page" do
    sign_in @admin
    get admin_customer_path(@customer)
    assert_response :success
  end

  test "customer cannot access admin customers page" do
    sign_in @customer
    get admin_customers_path
    assert_redirected_to root_path
  end
end
