class ApplicationController < ActionController::Base
  # Include Pundit authorization hooks
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_global_variables

  private

  def set_global_variables
    @store_categories = Category.where(parent_id: nil)
    session[:cart] ||= {}
    @cart_item_count = session[:cart].values.sum
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back_or_to(root_path)
  end
end
