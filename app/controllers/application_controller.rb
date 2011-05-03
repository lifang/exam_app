class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  def access?
    deny_access unless signed_in?
  end

end
