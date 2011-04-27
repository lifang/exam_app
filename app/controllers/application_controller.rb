class ApplicationController < ActionController::Base
  protect_from_forgery

  def lander
    User.find(cookies[:user_id])
  end

  def lander?(email)
    User.find(cookies[:user_id]).email==email
  end

end
