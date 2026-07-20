class Admin::CustomersController < Admin::BaseController
  before_action :set_customer, only: [:show]

  def index
    authorize User
    @q = User.where(role: "customer").ransack(params[:q])
    @customers = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    authorize @customer, policy_class: UserPolicy
    @orders = @customer.orders.recent.page(params[:page]).per(5)
  end

  private

  def set_customer
    @customer = User.find(params[:id])
  end
end
