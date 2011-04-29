class SessionsController < ApplicationController
  def index
    
  end

  def create
   @user = User.find_by_username(params[:session][:username])
   @authenticate = User.authenticate(params[:session][:username], params[:session][:password])
    if @authenticate.nil?
      flash[:error2] = "用户名不存在"
      render '/sessions/new'
    else
      cookies[:user_id]=@user.id
      cookies[:user_name]=@user.name
      redirect_to "/papers"
   end
  end
end
