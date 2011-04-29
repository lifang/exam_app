class UsersController < ApplicationController

  def index
    
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new(params[:user])
    if  (User.find_by_username(params[:user][:username]) !=nil)
      flash[:nameused] = "用户名已经存在,您可能已经注册过此账号，请去登录界面尝试能否成功登录。"
      redirect_to "/users/new"
    else
    if (User.find_by_email(params[:user][:email]) !=nil)
      flash[:emailused] = "此邮箱已被使用过，请使用其他邮箱。"
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
  def show
    @user=User.find(params[:id])
  end

end
