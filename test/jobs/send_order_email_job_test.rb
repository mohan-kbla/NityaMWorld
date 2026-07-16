require "test_helper"

class SendOrderEmailJobTest < ActiveJob::TestCase
  setup do
    @category = Category.create!(name: "Job Cat")
    @brand = Brand.create!(name: "Job Brand")
    @product = Product.create!(
      name: "Job Product",
      sku: "JOBPROD1",
      price: 100.0,
      stock: 5,
      category: @category,
      brand: @brand
    )

    @user = User.create!(
      email: "job@example.com",
      password: "password123",
      first_name: "Job",
      last_name: "Tester",
      phone: "111"
    )

    @shipping = Address.create!(address_type: "shipping", full_name: "S", address_line1: "L1", city: "C", state: "S", zip_code: "1", phone: "1")
    @billing = Address.create!(address_type: "billing", full_name: "B", address_line1: "L1", city: "C", state: "S", zip_code: "1", phone: "1")
    @order = Order.create!(
      user: @user,
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

  test "queues the order email job" do
    assert_enqueued_with(job: SendOrderEmailJob, args: [@order.id]) do
      SendOrderEmailJob.perform_later(@order.id)
    end
  end

  test "executes the job successfully" do
    # Verify the job executes without throwing errors
    assert_nothing_raised do
      SendOrderEmailJob.perform_now(@order.id)
    end
  end
end
