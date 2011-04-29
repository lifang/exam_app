class SessionsController < ApplicationController
  def index
    
  end

  def create
    @user = User.find_by_username(params[:session][:username])
   
    if @user.nil?
      flash[:error2] = "用户不存在"
      redirect_to '/sessions/new'
    else
      if  @user.has_password?(params[:session][:password])
        cookies[:user_id]=@user.id
        cookies[:user_name]=@user.name
        redirect_to "/papers"
      else
        flash[:error2] = "密码错误"
        redirect_to '/sessions/new'
      

      end
    end
  end
end
