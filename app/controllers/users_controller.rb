# encoding: utf-8
class UsersController < ApplicationController
  require 'spreadsheet'
  
  def update #更新密码
    @user =User.find(params[:id])
    if @user.has_password?(params[:user][:old_password])
      @user.update_attributes(:password=>params[:user][:password])
      @user.encrypt_password
      @user.save
      flash[:notice]="密码修改成功"
      redirect_to "/users/#{params[:id]}/edit"
    else
      flash[:error]="您输入的密码不正确"
      redirect_to "/users/#{params[:id]}/edit"
    end
  end

  def index
    @users = User.paginate(:per_page=>10,:page=>params[:page])
    @roles = Role.all
  end

  def index_search
    sql ="select * from users"
    sql +=" where" if (params[:user_name]!=""||params[:user_email]!="")
    sql +=" name='#{params[:user_name]}'" unless params[:user_name]==""
    sql +=" and" if (params[:user_name]!=""&&params[:user_email]!="")
    sql +=" email='#{params[:user_email]}'" unless params[:user_email]==""
    @users = User.find_by_sql(sql).paginate(:per_page=>10,:page=>params[:page])
    render "index"
  end

  def update_info #更新用户信息
    @user_info = User.find(params[:id])
    @user_info.update_attributes(params[:user_info])
    flash[:notice]="用户信息修改成功"
    redirect_to "/users/#{params[:id]}/edit"
  end
  
  def new #新建用户页面
    session[:register_proof_code] = proof_code(4)
    @user=User.new
  end

  def create  #新建用户
    @user=User.new(params[:user])
    if (User.find_by_email(params[:user][:email]) !=nil)
      flash[:emailused] = "此邮箱已被使用，请使用其他邮箱。"
      redirect_to "/users/new"
    else
      @user.username=params[:user][:name]
      @user.status = User::STATUS[:LOCK]
      @user.active_code = proof_code(6)
      @user.set_role(Role.find(Role::TYPES[:STUDENT]))
      @user.encrypt_password
      if @user.save!
        UserMailer.welcome_email(@user).deliver
        redirect_to "/users/#{@user.id}/active"
      else
        redirect_to "/users/new"
      end
    end
  end

  def re_active  #用户确认
    @flag = false
    unless params[:user_id].blank?
      @user = User.first(:conditions => ["id = ?", params[:user_id].to_i])
      if @user.status == true
        render :partial => "/users/re_active"
      else
        @flag = true
        UserMailer.welcome_email(@user).deliver
        render :partial => "/users/re_active"
      end if @user
    end
  end

  def active
    @user = User.find(params[:id].to_i)
  end

  def user_active  #确认成功
    if !params[:id].blank? and !params[:active_code].blank?
      @user = User.first(:conditions => ["id = ? and active_code = ?", params[:id].to_i, params[:active_code]])
      if @user
        @user.active_code = ""
        @user.status = true
        @user.save!
        redirect_to "/users/active_success"
      else
        redirect_to "/users/active_false"
      end
    end
  end
      
  def get_proof_code
    session[:proof_code] = proof_code(4)
    render :inline => session[:proof_code]
  end

  

  def edit
    @user= User.find(params[:id])
  end

  def get_register_code
    session[:register_proof_code] = proof_code(4)
    render :inline => session[:register_proof_code]
  end

  def roles_manage
    @roles = Role.all
  end

  def load_set_right
    @rights = Constant::RIGHTS
    @role = Role.find(params[:role_id])
    render :partial => "/users/set_right",:object =>@role
  end

  def set_right
    @role_id=params[:right][:role_id].to_i
    @rights_num=params[:right][:right_num].to_i
    @right_sum=0
    (0..@rights_num).each do |id|
      puts params["check_box#{id}"]
      if params["check_box#{id}"]!=nil && params["check_box#{id}"] != ""
        @right_sum += params["check_box#{id}"].to_i
      end
    end
    @model_role = ModelRole.find_by_role_id(@role_id)
    if @model_role == nil
      ModelRole.create(:role_id=>@role_id,:right_sum=>@right_sum)
    else
      @model_role.update_attributes(:right_sum=>@right_sum)
    end
    redirect_to request.referer
  end

  def load_edit_role
    @role = Role.find(params[:role_id].to_i)
    render :partial => "/users/edit_role",:object =>@role
  end

  def edit_role
    @role = Role.find(params[:role][:role_id].to_i)
    @role_name = params[:role_name_test]
    @role.update_attributes(:name=>@role_name)
    redirect_to request.referer
  end
  
  def add_role
    @role=Role.create(:name=>params[:role][:name])
    redirect_to request.referer
  end

  def load_set_role
    @user = User.find(params[:user_id])
    @roles = Role.all
    render :partial => "/users/set_role",:object =>@user
  end

  def set_role
    @user_id=params[:role][:user_id].to_i
    @roles_num=params[:role][:num].to_i
    User.find(@user_id).user_role_relations.each do |relation|
      relation.destroy
    end
    (1..@roles_num).each do |id|
      if params["check_box#{id}"]!=nil && params["check_box#{id}"] != ""
        UserRoleRelation.create(:user_id=>@user_id,:role_id=>params["check_box#{id}"].to_i)
      end
    end
    redirect_to "/users"
  end

  def do_export_info
    if params[:all].to_s == "true"
      users = User.find_by_sql("select u.name, u.email from users u where u.status = #{User::STATUS[:NORMAL]} ")
    else
      other_sql = ""
      year = params[:year_arr].split(";")
      year.each do |y|
        month = y.split(",")
        unless month[1].nil?
          day = (month[1].to_i*6 < 10) ? ("0" + (month[1].to_i*6).to_s + "30") : ((month[1].to_i*6).to_s + "31")
          start_day = (month[0] + "0" + ((month[1].to_i-1)*6 + 1).to_s + "01").to_date
          end_day = (month[0] + day).to_date
          other_sql += " (u.created_at >= '#{start_day}' and u.created_at <= '#{end_day} 23:59:59') "
        end
        unless month[2].nil?
          start_day = (month[0] + "0" +  ((month[2].to_i-1)*6 + 1).to_s + "01").to_date
          end_day = (month[0] + (month[2].to_i*6).to_s + "31").to_date
          other_sql += " or " unless other_sql.nil?
          other_sql += " (u.created_at >= '#{start_day}' and u.created_at <= '#{end_day} 23:59:59') "
        end
        users = User.find_by_sql(["select u.name, u.email from users u where (#{other_sql})
          and  u.status = #{User::STATUS[:NORMAL]}"])
      end unless year.blank?
    end
    if users.blank?
      render :inline => "<script>alert('您选择的时间段内没有注册的用户。');</script>"
    else
      url = Constant::PUBLIC_PATH + "/user_info"
      unless File.directory?(url)               #判断dir目录是否存在，不存在则创建 下3行
        Dir.mkdir(url)
      end
      file_url = "/#{Time.now.strftime("%Y%m%d%H%M%S")}.xls"
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet
      sheet.row(0).concat %w{姓名 邮箱}
      users.each_with_index do |exam_user, index|
        sheet.row(index+1).concat ["#{exam_user.name}", "#{exam_user.email}"]
      end
      book.write url + file_url
      render :inline => "<script>window.location.href='/user_info#{file_url}';</script>"
    end
    
  end


end

