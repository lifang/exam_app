class ExamUsersController < ApplicationController
  require 'rexml/document'
  include REXML
  def create_exam_user  #单个添加考生
    @examination = Examination.find(params[:examination_id].to_i)
    @user=User.find_by_sql("select * from users u where u.name='#{params[:exam_user_infoname]}' and u.email='#{params[:exam_user_infoemail]}' ")
    if @user==[]
      if User.find_by_email(params[:exam_user_infoemail])!=nil
        flash[:email_err]="邮箱已被使用"
      else
        user = User.new(:name=>params[:exam_user_infoname],:username=>params[:exam_user_infoname],:email=>params[:exam_user_infoemail],
          :mobilephone=>params[:exam_user_infomobile],:password=>"123456",:password_confirmation=>"123456")
        user.set_role(Role.find(Role::TYPES[:STUDENT]))
        user.status = User::STATUS[:NORMAL]
        user.encrypt_password
        user.save!
        new_exam_user(@examination,user)
      end
    else
      @user.each  do |user1|
        if ExamUser.find_by_user_id(user1.id).nil?
          new_exam_user(@examination,user1)
        else
          if ExamUser.find_by_examination_id_and_user_id(params[:examination_id],user1.id)
            flash[:email_err]="该考生信息已加入"
          else
            new_exam_user(@examination,user1)
          end
        end
      end
    end
    @exam_users = ExamUser.paginate_exam_user(@examination.id, 1, params[:page])
    render :partial => "/examinations/exam_user_for_now"
  end

  def new_exam_user(examination,user) #创建考生
    exam_user = ExamUser.create!(:user_id=>user.id,:examination_id=>params[:examination_id],:password=>"123456",
      :is_user_affiremed=>ExamUser::IS_USER_AFFIREMED[:NO])
    exam_user.set_paper(examination)
    if examination.user_affirm==true
      UserMailer.user_affirm(exam_user,examination).deliver
    end
  end
  def exam_user_affiremed   #考生确认
    if !params[:id].blank? and !params[:affiremed].blank?
      @exam_user = ExamUser.first(:conditions => ["id = ? and is_user_affiremed = ?", params[:id].to_i, params[:affiremed]])
      @user=User.find(params[:user_id])
      if @exam_user
        @examination=Examination.find(@exam_user.examination_id)
        flash[:title]=",恭喜您参加 #{@examination.title} 的考试,请确认！"
        render "/exam_users/affiremed_success"
      else
        redirect_to "/exam_users/affiremed_false"
      end
    end
  end
  def edit_name #考生确认时修改考生姓名
    @examination=Examination.find(params[:examination])
    @exam_user=ExamUser.find(params[:exam_user])
    @user=User.find(params[:id])
    @exam_user.user_affiremed
    @user.name=params[:name]
    flash[:success]="恭喜您成功确认"
    @exam_user.save
    @user.save
    render "/exam_users/affiremed_success"
  end
  def login   #批量添加考生
    @examination = Examination.find(params[:id].to_i)
    @info_class=get_text(params[:user_info])
    i=0
    str="发现信息重复加入的考生："
    str1="发现邮箱已被占用："
    (0..@info_class.length/3-1).each do
      @user=User.find_by_sql("select * from users u where u.name='#{@info_class[i]}' and u.email='#{@info_class[i+1]}' ")
      if @user==[]
        if User.find_by_email(@info_class[i+1])!=nil
          str1 +=@info_class[i]+","+@info_class[i+1]+";"
        else
          user = User.new(:name=>@info_class[i],:username=>@info_class[i],:email=>@info_class[i+1],:mobilephone=>@info_class[i+2],:password=>"123456",:password_confirmation=>"123456")
          user.set_role(Role.find(Role::TYPES[:STUDENT]))
          user.status = User::STATUS[:NORMAL]
          user.encrypt_password
          user.save!
          new_exam_user(@examination,user)
        end
      else
        @user.each  do |user1|
          if ExamUser.find_by_user_id(user1.id).nil?
            new_exam_user(@examination,user1)
          else
            if ExamUser.find_by_examination_id_and_user_id(params[:id],user1.id)   
              str +=@info_class[i]+","+@info_class[i+1]+";"
            else
              new_exam_user(@examination,user1)
            end
          end
        end
      end
      i +=3
    end
    if str=="" && str1==""
      render :text =>"考生信息都已成功加入"
    else
      render :text => "<font color='blue'>#{str1}&nbsp;&nbsp;<br/>#{str}</font>"
    end
  
  end

  def destroy #删除考生
    exam_user = ExamUser.find(params[:id].to_i)
    exam_user.destroy
    @examination = Examination.find(exam_user.examination_id)
    @exam_users =ExamUser.paginate_exam_user(exam_user.examination_id, 1, params[:page])
    render :partial=>"/examinations/exam_user_for_now"
    #    render :inline => ""
  end
  def edit  #编辑按钮
    @exam_user =ExamUser.find(params[:id].to_i)
    @user=User.find(ExamUser.find(params[:id].to_i).user_id)
    render :partial=>"/examinations/edit_exam_user"
  end

  def update_exam_user  #编辑考生信息
    @exam_user =ExamUser.find(params[:id].to_i)
    @user=User.find(ExamUser.find(params[:id].to_i).user_id)
    @user.update_attributes(:name=>params[:name],:username=>params[:name],:email=>params[:email],
      :mobilephone=>params[:mobilephone])
    render :partial=>"/examinations/back_exam_user"
  end
  
  def my_results   #考生成绩
    @exam_user=ExamUser.find_by_user_id(cookies[:user_id])
    sql = ExamUser.generate_result_sql
    sql += " and us.id=#{cookies[:user_id]} "
    @results=Examination.paginate_by_sql(sql,:per_page =>5, :page => params[:page])
  end
  def search
    session[:start_at] = nil
    session[:end_at] = nil
    session[:title] = nil
    session[:start_at] = params[:start_at] if !params[:start_at].nil? and params[:start_at] != ""
    session[:end_at] = params[:end_at] if !params[:end_at].nil? and params[:end_at] != ""
    session[:title] = params[:title] if !params[:title].nil? and params[:title] != ""
    redirect_to search_list_exam_users_path
  end
  
  def search_list #成绩查询
    @exam_user=ExamUser.find_by_user_id(cookies[:user_id])
    sql = ExamUser.generate_result_sql
    sql += " and us.id=#{cookies[:user_id]}"
    sql += " and e.start_at_time >= '#{session[:start_at]}'" unless session[:start_at].nil?
    sql += " and e.start_at_time <= '#{session[:end_at]}'" unless session[:end_at].nil?
    sql += " and e.title like '%#{session[:title]}%'" unless session[:title].nil?
    @results = Examination.paginate_by_sql(sql, :pre_page => 1, :page => params[:page])
    render "my_results"
  end

  def show
    result=ExamUser.find(params[:id])
    exam=ExamUser.find_by_user_id_and_examination_id(cookies[:user_id],result.examination_id)
    answer=File.open("#{Rails.root}/public/#{result.id}.xml")
    @doc=Document.new(answer).root
    file = File.open("#{Constant::PAPER_PATH}/#{exam.paper_id}.xml")
    @xml=Document.new(file).root
  end
end
