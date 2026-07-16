class Admin::BannersController < Admin::BaseController
  before_action :set_banner, only: [:edit, :update, :destroy]

  def index
    @banners = Banner.ordered.page(params[:page]).per(10)
  end

  def new
    @banner = Banner.new
    authorize @banner
  end

  def create
    @banner = Banner.new(banner_params)
    authorize @banner
    if @banner.save
      redirect_to admin_banners_path, notice: "Banner created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @banner
  end

  def update
    authorize @banner
    if @banner.update(banner_params)
      redirect_to admin_banners_path, notice: "Banner updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @banner
    @banner.destroy
    redirect_to admin_banners_path, notice: "Banner deleted successfully!"
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(:title, :subtitle, :link_url, :active, :position, :image)
  end
end
