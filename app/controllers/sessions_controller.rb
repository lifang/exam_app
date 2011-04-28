class SessionsController < ApplicationController
  def index
    
  end

  def create
   @user=User.find_by_user_name(params[:session][:user_name])
    if @user.nil?
     # flash[:error] = "您输入的邮箱或者密码错误，请重新输入。"
      render '/sessions/new'
    else
      session[:user_name]=@user.user_name
      session[:user_password]=@user.password
      redirect_to "/papers"
   end
  end
end
