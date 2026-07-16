class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).includes(:category, :brand).page(params[:page]).per(10)
  end

  def show
    authorize @product
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      redirect_to admin_product_path(@product), notice: "Product created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    @product.destroy
    redirect_to admin_products_path, notice: "Product deleted successfully!"
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :sku, :description, :short_description, :price, :discount_price,
      :stock, :weight, :featured, :best_seller, :new_arrival, :category_id, :brand_id,
      :meta_title, :meta_description, images: []
    )
  end
end
