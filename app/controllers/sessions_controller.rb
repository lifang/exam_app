class SessionsController < ApplicationController
  def new
    session[:signin_code] = proof_code(4)
  end
  def index
  end
  def create

    if params[:proof_code].downcase != session[:signin_code].to_s.downcase
      flash[:error] = "请输入正确的验证码"
      redirect_to '/sessions/new'
    else
      @user = User.find_by_email(params[:session][:email])
      if @user.nil?
        flash[:error] = "邮箱不存在"
        redirect_to '/sessions/new'
      else
        unless  @user.has_password?(params[:session][:password])
          flash[:error] = "密码错误"
          redirect_to '/sessions/new'
        else
          if @user.status == User::STATUS[:LOCK]
            flash[:error] = "您的账号还未激活，请查找您注册邮箱的激活信进行激活"
            redirect_to '/sessions/new'
          else
            cookies[:user_id]=@user.id
            cookies[:user_name]=@user.name
              redirect_to "/papers"            
          end
        end
      end
    end
  end

  def destroy
    cookies.delete(:user_id)
    cookies.delete(:user_name)
    redirect_to root_path
  end
end
