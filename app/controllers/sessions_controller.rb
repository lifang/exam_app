class SessionsController < ApplicationController
  def index
    
  end

  def new
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
     # flash[:error] = "您输入的邮箱或者密码错误，请重新输入。"
      render 'new'
    else
      session[:user_email]= params[:session][:email]
      redirect_to "/users/#{user.id}"
    end
  end
end
