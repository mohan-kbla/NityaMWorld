class Admin::BaseController < ApplicationController
  # Require authentication for all admin controllers
  before_action :authenticate_user!
  
  # Ensure the user has admin or staff privileges
  before_action :require_admin!

  layout "admin"

  private

  def require_admin!
    unless current_user.admin? || current_user.staff?
      flash[:alert] = "You are not authorized to access the admin area."
      redirect_to root_path
    end
  end
end
