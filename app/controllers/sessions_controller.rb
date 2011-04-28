class SessionsController < ApplicationController
  def index
    
  end

  def create
   @user = User.find_by_username(params[:session][:username])
   @authenticate = User.authenticate(params[:session][:username], params[:session][:password])
    if @authenticate.nil?
     # flash[:error] = "您输入的邮箱或者密码错误，请重新输入。"
      render '/sessions/new'
    else
      cookies[:user_name]=@user.name
      redirect_to "/papers"
   end
  end
end
