module ApplicationHelper
  def current_user
    User.find_by_id(cookies[id])
  end
end
