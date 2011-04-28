class SessionsController < ApplicationController
  def index
    
  end

  def create
   @user = User.authenticate(params[:session][:username], params[:session][:password])
    if @user.nil?
     # flash[:error] = "您输入的邮箱或者密码错误，请重新输入。"
      render '/sessions/new'
    else
      session[:user_name]=@user.username
      session[:user_password]=@user.password
      redirect_to "/papers"
   end
  end
end
