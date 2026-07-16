class Admin::BlogsController < Admin::BaseController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  def index
    @blogs = BlogPost.recent.page(params[:page]).per(10)
  end

  def show
    authorize @blog
  end

  def new
    @blog = BlogPost.new
    authorize @blog
  end

  def create
    @blog = BlogPost.new(blog_params)
    authorize @blog
    if @blog.save
      redirect_to admin_blog_path(@blog), notice: "Blog post created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @blog
  end

  def update
    authorize @blog
    if @blog.update(blog_params)
      redirect_to admin_blog_path(@blog), notice: "Blog post updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @blog
    @blog.destroy
    redirect_to admin_blogs_path, notice: "Blog post deleted successfully!"
  end

  private

  def set_blog
    @blog = BlogPost.friendly.find(params[:id])
  end

  def blog_params
    params.require(:blog_post).permit(:title, :content, :published_at, :meta_title, :meta_description, :image)
  end
end
