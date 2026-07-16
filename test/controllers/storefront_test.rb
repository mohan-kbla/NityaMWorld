require "test_helper"

class StorefrontTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @category = Category.create!(name: "Store Cat")
    @brand = Brand.create!(name: "Store Brand")
    @product = Product.create!(
      name: "Store Product",
      sku: "STOREPROD1",
      price: 500.00,
      stock: 10,
      category: @category,
      brand: @brand
    )

    @coupon = Coupon.create!(
      code: "DISCOUNT50",
      discount_type: "flat",
      discount_value: 50.00,
      min_order_amount: 100.00,
      active: true
    )

    @user = User.create!(
      email: "cust@example.com",
      password: "password123",
      first_name: "John",
      last_name: "Customer",
      phone: "999"
    )
  end

  test "adding items to cart and clearing cart" do
    # Initially empty cart
    get cart_path
    assert_response :success
    assert_select "h3", "Your cart is empty"

    # Add item
    post add_item_cart_path(product_id: @product.id, quantity: 2)
    assert_redirected_to cart_path
    follow_redirect!

    assert_select "h6 a", "Store Product"
    # Total price matches active price * 2
    assert_select "td.text-end.fw-bold", /₹1000.00/

    # Update item quantity
    patch cart_path, params: { product_id: @product.id, quantity: 3 }
    assert_redirected_to cart_path
    follow_redirect!
    assert_select "td.text-end.fw-bold", /₹1500.00/

    # Remove item
    delete cart_path(product_id: @product.id)
    assert_redirected_to cart_path
    follow_redirect!
    assert_select "h3", "Your cart is empty"
  end

  test "applying coupon discounts" do
    # Add item to cart
    post add_item_cart_path(product_id: @product.id, quantity: 1)

    # Apply valid coupon
    post apply_coupon_cart_path(coupon_code: "DISCOUNT50")
    assert_redirected_to cart_path
    follow_redirect!

    assert_select "tr.text-danger td", /-₹50.00/
    # Grand Total: 500 subtotal - 50 discount + 0 shipping (since free shipping over 1000 is not met but let's check shipping fee: subtotal is 500 so shipping is 100. Total should be 500 - 50 + 100 = 550)
    assert_select "td.text-end.pt-3", /₹550.00/
  end

  test "completing guest checkout placement and stock decrement" do
    # Add item to cart
    post add_item_cart_path(product_id: @product.id, quantity: 2)

    # Fill address details
    post checkout_index_path, params: {
      guest_email: "guest@example.com",
      billing_same_as_shipping: "1",
      shipping_address: {
        full_name: "Guest Checkout",
        address_line1: "Road 123",
        city: "Mumbai",
        state: "Maharashtra",
        zip_code: "400001",
        country: "India",
        phone: "9876543210"
      }
    }
    assert_redirected_to payment_checkout_index_path
    follow_redirect!
    assert_select "label", /Cash on Delivery \(COD\)/

    # Submit COD payment callback - creates order and decrements stock
    assert_difference("Order.count", 1) do
      assert_difference("OrderItem.count", 1) do
        post payment_callback_checkout_index_path, params: {
          payment_method: "cod",
          notes: "Fragile item"
        }
      end
    end

    # Stock is decremented (10 - 2 = 8)
    @product.reload
    assert_equal 8, @product.stock

    # Check redirect to order confirmation
    assert_redirected_to confirmation_checkout_index_path(order_id: Order.last.id)
    follow_redirect!
    assert_select "h2", "Order Confirmed!"
    assert_select "strong", "COD"
  end

  test "review moderation display rules" do
    # Guest review list is empty
    get shop_path(@product.slug)
    assert_response :success
    assert_select "p", "No reviews yet. Be the first to review this product!"

    # Login and submit review
    sign_in @user
    post reviews_path, params: {
      review: {
        product_id: @product.id,
        rating: 5,
        title: "Highly Recommend",
        body: "Best homely food ever!"
      }
    }
    assert_redirected_to shop_path(@product.slug)
    follow_redirect!
    assert_select "div.alert-success", /submitted and is pending moderation/

    # It should not show up yet (still pending approval)
    get shop_path(@product.slug)
    assert_select "h6", { count: 0, text: /John Customer/ }

    # Admin approves review
    review = Review.last
    review.update!(status: "approved")

    # Now it should show up on product page!
    get shop_path(@product.slug)
    assert_select "h6", /John Customer/
    assert_select "strong", "Highly Recommend"
  end
end
