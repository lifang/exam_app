class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper
  def current_user
    User.find_by_username(cookies[:username])
  end

end
