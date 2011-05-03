class UsersController < ApplicationController

  def index

  end

  def new
    @ss = proof_code()
    @user=User.new
  end

  def create
    @user=User.new(params[:user])
    if  (User.find_by_username(params[:user][:username]) !=nil)
      flash[:nameused] = "用户名已经存在,请重新输入用户名"
      redirect_to "/users/new"
    else
      if (User.find_by_email(params[:user][:email]) !=nil)
        flash[:emailused] = "此邮箱已被使用，请使用其他邮箱。"
        redirect_to "/users/new"
      else
        if User.new(params[:ss]) != @ss
          flash[:prooferror] = "验证码填写错误，请重新输入"
         redirect_to "/users/new"
        else
        if @user.save
          redirect_to "/sessions/new"
        else
          redirect_to "/users/new"
        end
        end
      end
    end
  

  end
  def show
    @user=User.find(params[:id])
  end

end
