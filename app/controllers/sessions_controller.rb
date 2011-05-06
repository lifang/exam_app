class SessionsController < ApplicationController
  def new
    session[:signin_code] = proof_code()
  end
 
  def index
    
  end

  def create
    @user = User.find_by_username(params[:session][:username])
    if @user.nil?
      flash[:error2] = "用户不存在"
      redirect_to '/sessions/new'
    else
      unless  @user.has_password?(params[:session][:password])    
        flash[:error2] = "密码错误"
        redirect_to '/sessions/new'
      else
      if params[:proof_code] != session[:signin_code]
        flash[:error] = "请输入正确的验证码"
        redirect_to '/sessions/new'
        
      else
        cookies[:user_id]=@user.id
        cookies[:user_name]=@user.name
        redirect_to "/papers"
      end
    end
    end
  end

  def destroy
    cookies.delete(:user_id)
    redirect_to root_path
  end
end
