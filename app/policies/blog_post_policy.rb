class BlogPostPolicy < ApplicationPolicy
  def index?
    user.admin? || user.staff?
  end

  def show?
    user.admin? || user.staff?
  end

  def create?
    user.admin? || user.staff?
  end

  def update?
    user.admin? || user.staff?
  end

  def destroy?
    user.admin?
  end
end
