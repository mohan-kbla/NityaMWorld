class ReviewPolicy < ApplicationPolicy
  def index?
    user.admin? || user.staff?
  end

  def approve?
    user.admin? || user.staff?
  end

  def reject?
    user.admin? || user.staff?
  end

  def destroy?
    user.admin?
  end
end
