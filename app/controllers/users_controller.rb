class UsersController < ApplicationController

  def index

  end

  def new
    session[:proof_code] = proof_code()
    @user=User.new
  end

  def create
    
    @user=User.new(params[:user])
    if  (User.find_by_username(params[:user][:username]) !=nil)
      flash[:nameused] = "用户名已经存在,请重新输入用户名"
      render "/users/new"
    else
      if (User.find_by_email(params[:user][:email]) !=nil)
        flash[:nameused] = ""
        flash[:emailused] = "此邮箱已被使用，请使用其他邮箱。"
        render "/users/new"
      else
  
        if params[:proof_code] != session[:proof_code]
          flash[:nameused] = ""
          flash[:emailused] = ""
          flash[:prooferror] = "验证码填写错误，请重新输入"
          render "/users/new"
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
  def get_proof_code
    session[:proof_code] = proof_code()
    render :inline => session[:proof_code]
  end
  def edit
   # @user= User.find(params[:id])
  end
end

