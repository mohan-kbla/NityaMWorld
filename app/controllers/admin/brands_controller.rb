class Admin::BrandsController < Admin::BaseController
  before_action :set_brand, only: [:show, :edit, :update, :destroy]

  def index
    @brands = Brand.page(params[:page]).per(10)
  end

  def show
    authorize @brand
  end

  def new
    @brand = Brand.new
    authorize @brand
  end

  def create
    @brand = Brand.new(brand_params)
    authorize @brand
    if @brand.save
      redirect_to admin_brands_path, notice: "Brand created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @brand
  end

  def update
    authorize @brand
    if @brand.update(brand_params)
      redirect_to admin_brands_path, notice: "Brand updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @brand
    if @brand.destroy
      redirect_to admin_brands_path, notice: "Brand deleted successfully!"
    else
      redirect_to admin_brands_path, alert: @brand.errors.full_messages.to_sentence
    end
  end

  private

  def set_brand
    @brand = Brand.friendly.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name, :description, :image)
  end
end
