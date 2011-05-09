class UsersController < ApplicationController

  def index

  end

  def new
    session[:register_proof_code] = proof_code(4)
    @user=User.new
  end

  def create
    @user=User.new(params[:user])
    if  (User.find_by_username(params[:user][:username]) !=nil)
      flash[:nameused] = "用户名已经存在,请重新输入用户名"
      render "/users/new"
    else
      if (User.find_by_email(params[:user][:email]) !=nil)
        flash[:emailused] = "此邮箱已被使用，请使用其他邮箱。"
        render "/users/new"
      else
        if params[:proof_code] != session[:register_proof_code]
          flash[:prooferror] = "验证码填写错误，请重新输入"
          render "/users/new"
        else
          @user.status = User::STATUS[:LOCK]
          @user.active_code = proof_code(6)
          if params[:user][:role].to_i == Role::TYPES[:TEACHER]
            @user.roles << Role.find(Role::TYPES[:TEACHER])
          else
            @user.roles << Role.find(Role::TYPES[:STUDENT])
          end
          if @user.save
            UserMailer.welcome_email(@user).deliver
            redirect_to "/users/#{@user.id}/active"
          else
            redirect_to "/users/new"
          end
        end
      end
    end
  end

  def re_active
    @flag = false
    if !params[:user_id].blank?
      @user = User.first(:conditions => ["id = ?", params[:user_id].to_i])
      if @user
        if @user.status == true
          render :partial => "/users/re_active"
        else
          @flag = true
          UserMailer.welcome_email(@user).deliver
          render :partial => "/users/re_active"
        end
      end
    end
  end

  def active
    @user = User.find(params[:id].to_i)
  end

  def user_active
    if !params[:id].blank? and !params[:active_code].blank?
      user = User.first(:conditions => ["id = ? and active_code = ?", params[:id].to_i, params[:active_code]])
      if user
        user.active_code = ""
        user.status = true
        user.save!
        redirect_to "/users/active_success"
      else
        redirect_to "/users/active_false"
      end
    end
  end

  def show
    @user=User.find(params[:id])
  end
  def get_proof_code
    session[:proof_code] = proof_code(4)
    render :inline => session[:proof_code]
  end
  def edit
    @user= User.find(params[:id])
  end

  def update
    @user= User.find(params[:id])
    @user.update_attributes(params[:user])
    redirect_to @user
  end

  def get_register_code
    session[:register_proof_code] = proof_code(4)
    render :inline => session[:register_proof_code]
  end

end

