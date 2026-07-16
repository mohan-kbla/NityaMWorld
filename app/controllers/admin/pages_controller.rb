class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.page(params[:page]).per(10)
  end

  def show
    authorize @page
  end

  def new
    @page = Page.new
    authorize @page
  end

  def create
    @page = Page.new(page_params)
    authorize @page
    if @page.save
      redirect_to admin_page_path(@page), notice: "Static page created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @page
  end

  def update
    authorize @page
    if @page.update(page_params)
      redirect_to admin_page_path(@page), notice: "Static page updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @page
    @page.destroy
    redirect_to admin_pages_path, notice: "Static page deleted successfully!"
  end

  private

  def set_page
    @page = Page.friendly.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :content, :active, :meta_title, :meta_description)
  end
end
