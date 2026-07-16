class CheckoutController < ApplicationController
  before_action :ensure_cart_not_empty, except: [:confirmation]
  before_action :set_cart_totals, except: [:confirmation]

  def new
    @shipping_address = Address.new(address_type: "shipping")
    @billing_address = Address.new(address_type: "billing")
  end

  def create
    shipping_params = params.require(:shipping_address).permit(:full_name, :address_line1, :address_line2, :city, :state, :zip_code, :country, :phone)
    
    if params[:billing_same_as_shipping] == "1"
      billing_params = shipping_params.dup
    else
      billing_params = params.require(:billing_address).permit(:full_name, :address_line1, :address_line2, :city, :state, :zip_code, :country, :phone)
    end

    guest_email = params[:guest_email]

    @shipping_address = Address.new(shipping_params.merge(address_type: "shipping"))
    @billing_address = Address.new(billing_params.merge(address_type: "billing"))

    if @shipping_address.valid? && @billing_address.valid?
      @shipping_address.save!
      @billing_address.save!

      session[:shipping_address_id] = @shipping_address.id
      session[:billing_address_id] = @billing_address.id
      session[:guest_email] = guest_email if guest_email.present?

      redirect_to payment_checkout_index_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def payment
    @shipping_address = Address.find_by(id: session[:shipping_address_id])
    @billing_address = Address.find_by(id: session[:billing_address_id])
    
    unless @shipping_address && @billing_address
      redirect_to new_checkout_path, alert: "Please enter your address details first."
    end
  end

  def payment_callback
    @shipping_address = Address.find(session[:shipping_address_id])
    @billing_address = Address.find(session[:billing_address_id])
    
    user = current_user
    payment_method = params[:payment_method]

    ActiveRecord::Base.transaction do
      order = Order.new(
        user: user,
        status: "pending",
        payment_method: payment_method,
        payment_status: (payment_method == "cod" ? "pending" : "paid"),
        shipping_address: @shipping_address,
        billing_address: @billing_address,
        subtotal_amount: @subtotal,
        shipping_amount: @shipping_fee,
        discount_amount: @discount,
        total_amount: @total,
        notes: params[:notes]
      )

      if session[:coupon_code].present?
        coupon = Coupon.active.find_by(code: session[:coupon_code])
        if coupon
          order.coupon = coupon
          coupon.update!(usage_count: coupon.usage_count + 1)
        end
      end

      order.save!

      session[:cart].each do |prod_id, qty|
        product = Product.find(prod_id)
        raise ActiveRecord::Rollback if product.stock < qty
        
        OrderItem.create!(
          order: order,
          product: product,
          quantity: qty,
          price: product.active_price,
          total_price: product.active_price * qty
        )
        product.update!(stock: product.stock - qty)
      end

      session[:cart] = {}
      session[:coupon_code] = nil
      session[:shipping_address_id] = nil
      session[:billing_address_id] = nil

      # Queue background order confirmation email
      SendOrderEmailJob.perform_later(order.id)

      redirect_to confirmation_checkout_index_path(order_id: order.id)
    end
  rescue => e
    redirect_to cart_path, alert: "There was an error processing your order: #{e.message}"
  end

  def confirmation
    @order = Order.find(params[:order_id])
  end

  private

  def ensure_cart_not_empty
    if session[:cart].blank?
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end

  def set_cart_totals
    @subtotal = 0
    session[:cart].each do |prod_id, qty|
      product = Product.find_by(id: prod_id)
      @subtotal += product.active_price * qty if product
    end

    @discount = 0
    if session[:coupon_code].present?
      coupon = Coupon.active.find_by(code: session[:coupon_code])
      @discount = coupon.calculate_discount(@subtotal) if coupon && coupon.valid_for?(@subtotal)
    end

    @shipping_fee = @subtotal > 0 && @subtotal < 1000 ? 100.00 : 0.00
    @total = @subtotal - @discount + @shipping_fee
  end
end
