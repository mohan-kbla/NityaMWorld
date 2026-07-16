class CartsController < ApplicationController
  before_action :set_cart_items, only: [:show, :apply_coupon, :remove_coupon]

  def show
    @subtotal = 0
    @cart_items.each do |item|
      @subtotal += item[:product].active_price * item[:quantity]
    end

    @discount = 0
    if session[:coupon_code].present?
      coupon = Coupon.active.find_by(code: session[:coupon_code])
      if coupon && coupon.valid_for?(@subtotal)
        @discount = coupon.calculate_discount(@subtotal)
        @coupon_code = coupon.code
      else
        session[:coupon_code] = nil
      end
    end

    @shipping_fee = @subtotal > 0 && @subtotal < 1000 ? 100.00 : 0.00
    @total = @subtotal - @discount + @shipping_fee
  end

  def add_item
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i
    quantity = 1 if quantity <= 0

    session[:cart] ||= {}
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += quantity

    redirect_to cart_path, notice: "Product added to cart!"
  end

  def update
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    if quantity > 0
      session[:cart][product_id] = quantity
      flash[:notice] = "Cart updated successfully."
    else
      session[:cart].delete(product_id)
      flash[:notice] = "Item removed from cart."
    end

    redirect_to cart_path
  end

  def destroy
    product_id = params[:product_id].to_s
    if product_id.present?
      session[:cart].delete(product_id)
      flash[:notice] = "Item removed from cart."
    else
      session[:cart] = {}
      session[:coupon_code] = nil
      flash[:notice] = "Cart cleared."
    end
    redirect_to cart_path
  end

  def apply_coupon
    coupon_code = params[:coupon_code].to_s.strip.upcase
    coupon = Coupon.active.find_by(code: coupon_code)

    subtotal = 0
    @cart_items.each do |item|
      subtotal += item[:product].active_price * item[:quantity]
    end

    if coupon && coupon.valid_for?(subtotal)
      session[:coupon_code] = coupon.code
      redirect_to cart_path, notice: "Coupon '#{coupon.code}' applied successfully!"
    else
      redirect_to cart_path, alert: "Invalid coupon code or minimum order amount not met."
    end
  end

  def remove_coupon
    session[:coupon_code] = nil
    redirect_to cart_path, notice: "Coupon removed."
  end

  private

  def set_cart_items
    session[:cart] ||= {}
    @cart_items = []
    session[:cart].each do |prod_id, qty|
      product = Product.find_by(id: prod_id)
      if product
        @cart_items << { product: product, quantity: qty }
      else
        session[:cart].delete(prod_id)
      end
    end
  end
end
