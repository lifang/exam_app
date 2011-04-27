module ApplicationHelper
  def current_user
    User.find_by_email(session[:user_email])
  end
end
