# encoding: utf-8
class SessionsController < ApplicationController
  def new
    session[:signin_code] = proof_code(4)
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
            #            update_examination_status     # 不需要登录时更改状态，取消。
            redirect_to "/papers"
          end
        end
      end
    end
  end

  #更新考试状态
  #  def update_examination_status
  #    @examinations = Examination.all
  #    @examinations.each do |examination|
  #      if examination.start_at_time.nil?
  #        examination.update_attributes(:status=>2)
  #      elsif examination.start_at_time > Time.now
  #        examination.update_attributes(:status=>1)
  #      elsif (examination.exam_time.nil? and examination.exam_time !=0 and
  #            (examination.start_at_time + (examination.exam_time.nil? ? 0 :examination.exam_time.minutes) < Time.now))or
  #          examination.update_attributes(:status=>3)
  #      else
  #        examination.update_attributes(:status=>0)
  #      end
  #    end
  #  end

  #退出登录
  def destroy
    cookies.delete(:user_id)
    cookies.delete(:user_name)
    cookies.delete(:user_roles)
    redirect_to root_path
  end

  #获取更改密码的邮件
  def user_code
    user=User.find_by_email(params[:anonymous])
    if user
      UserMailer.update_code(user).deliver
      redirect_to "/sessions/#{user.id}/active"
    else
      flash[:error]="密码有误，请重新输入"
      render "/sessions/get_code"
    end
  end

  #填写密码界面
  def new_code
    @user=User.find(params[:id])
  end

  #更新密码
  def update_user_code
    user=User.find(params[:id])
    user.update_attributes(:password=>params[:session][:password])
    user.encrypt_password
    user.save
    flash[:success]="密码更新成功"
    redirect_to "/"
  end

  #收取邮件并登录
  def active
    @user = User.find(params[:id].to_i)
  end
end

