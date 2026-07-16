class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update, :invoice, :packing_slip, :cancel, :refund]

  def index
    @q = Order.ransack(params[:q])
    @orders = @q.result(distinct: true).includes(:user).recent.page(params[:page]).per(10)
  end

  def show
    authorize @order
  end

  def update
    authorize @order
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "Order updated successfully!"
    else
      render :show, status: :unprocessable_entity
    end
  end

  def invoice
    authorize @order, :invoice?
    render layout: false
  end

  def packing_slip
    authorize @order, :packing_slip?
    render layout: false
  end

  def cancel
    authorize @order, :cancel?
    if @order.status != "cancelled"
      ActiveRecord::Base.transaction do
        @order.order_items.each do |item|
          product = item.product
          product.update!(stock: product.stock + item.quantity)
        end
        @order.update!(status: "cancelled")
      end
      redirect_to admin_order_path(@order), notice: "Order cancelled and stock restored."
    else
      redirect_to admin_order_path(@order), alert: "Order is already cancelled."
    end
  end

  def refund
    authorize @order, :refund?
    if @order.status == "cancelled" || @order.payment_status == "paid"
      @order.update!(status: "refunded", payment_status: "refunded")
      redirect_to admin_order_path(@order), notice: "Order refunded successfully."
    else
      redirect_to admin_order_path(@order), alert: "Order cannot be refunded."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :tracking_number, :carrier, :notes, :payment_status)
  end
end
