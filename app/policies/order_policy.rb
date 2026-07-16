class OrderPolicy < ApplicationPolicy
  def index?
    user.admin? || user.staff?
  end

  def show?
    user.admin? || user.staff?
  end

  def update?
    user.admin? || user.staff?
  end

  def invoice?
    user.admin? || user.staff?
  end

  def packing_slip?
    user.admin? || user.staff?
  end

  def cancel?
    user.admin? || user.staff?
  end

  def refund?
    user.admin? # Only administrators can issue refunds
  end
end
