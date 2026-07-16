class Admin::TestimonialsController < Admin::BaseController
  before_action :set_testimonial, only: [:edit, :update, :destroy]

  def index
    @testimonials = Testimonial.page(params[:page]).per(10)
  end

  def new
    @testimonial = Testimonial.new
    authorize @testimonial
  end

  def create
    @testimonial = Testimonial.new(testimonial_params)
    authorize @testimonial
    if @testimonial.save
      redirect_to admin_testimonials_path, notice: "Testimonial created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @testimonial
  end

  def update
    authorize @testimonial
    if @testimonial.update(testimonial_params)
      redirect_to admin_testimonials_path, notice: "Testimonial updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @testimonial
    @testimonial.destroy
    redirect_to admin_testimonials_path, notice: "Testimonial deleted successfully!"
  end

  private

  def set_testimonial
    @testimonial = Testimonial.find(params[:id])
  end

  def testimonial_params
    params.require(:testimonial).permit(:author_name, :author_designation, :content, :rating, :active, :image)
  end
end
