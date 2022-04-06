module ApplicationHelper
  # is an admin or a user logged in?
  def current_session_scope
    if admin_signed_in?
      current_admin
    elsif user_signed_in?
      current_user
    else
      false
    end
  end

  def count_of(model)
    model.all.count
  end
end
