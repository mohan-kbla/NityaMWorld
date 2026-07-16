class Admin::CouponsController < Admin::BaseController
  before_action :set_coupon, only: [:show, :edit, :update, :destroy]

  def index
    @coupons = Coupon.page(params[:page]).per(10)
  end

  def show
    authorize @coupon
  end

  def new
    @coupon = Coupon.new
    authorize @coupon
  end

  def create
    @coupon = Coupon.new(coupon_params)
    authorize @coupon
    if @coupon.save
      redirect_to admin_coupons_path, notice: "Coupon created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @coupon
  end

  def update
    authorize @coupon
    if @coupon.update(coupon_params)
      redirect_to admin_coupons_path, notice: "Coupon updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @coupon
    @coupon.destroy
    redirect_to admin_coupons_path, notice: "Coupon deleted successfully!"
  end

  private

  def set_coupon
    @coupon = Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:coupon).permit(:code, :discount_type, :discount_value, :expiry_date, :usage_limit, :min_order_amount, :active)
  end
end
