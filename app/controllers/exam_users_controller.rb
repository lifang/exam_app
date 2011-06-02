class ExamUsersController < ApplicationController

  def create_exam_user
    @examination = Examination.find(params[:examination_id].to_i)
    if (User.find_by_name(params[:infoname])!=nil || User.find_by_email(params[:infoemail])!=nil)
      @user=User.find_by_sql("select u.id from users u where u.name='#{params[:infoname]}' and u.email='#{params[:infoemail]}' ")
      @user.each  do |user1|
        if ExamUser.find_by_user_id(user1.id).nil?
          new_exam_user(@examination,user1)
        else
          if (ExamUser.find_by_user_id(user1.id).examination_id ==params[:examination_id])
            flash[:email_err]="该考生信息已加入"
          else
            new_exam_user(@examination,user1)
          end
        end
      end
    else
      if User.find_by_email(params[:infoemail])!=nil
        flash[:email_err]="邮箱已被使用"
      else
        user = User.new(:name=>params[:infoname],:username=>params[:infoname],:email=>params[:infoemail],
          :mobilephone=>params[:infomobile],:password=>"123456",:password_confirmation=>"123456")
        user.set_role(Role.find(Role::TYPES[:STUDENT]))
        user.status = User::STATUS[:NORMAL]
        user.encrypt_password
        user.save!
        new_exam_user(@examination,user)
      end
    end
    @exam_users = ExamUser.paginate_exam_user(@examination.id, 1, params[:page])
    render :partial => "/examinations/exam_user_for_now"
  end
  def new_exam_user(examination,user)
    exam_user = ExamUser.create!(:user_id=>user.id,:examination_id=>params[:examination_id],:password=>"123456",
      :is_user_affiremed=>ExamUser::IS_USER_AFFIREMED[:NO],:total_score=>0)
    exam_user.set_paper(examination)
    if examination.user_affirm==true
      UserMailer.user_affirm(exam_user,examination).deliver
    end
  end
  def exam_user_affiremed
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
  def edit_name
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
  def login
    #    (1..params[:rows].to_i).each do |i|
    #         @user=User.new(:name=>params["infoname#{i}"],:username=>params["infoname#{i}"],:email=>params["infoemail#{i}"],:mobilephone=>params["infomobile#{i}"],:password=>"123456",:password_confirmation=>"123456")
    #      @user.status = User::STATUS[:NORMAL]
    #      @user.encrypt_password
    #      ExamUser.create!(:user_id=>@user.id,:examination_id=>cookies[:examination_id],:password=>"123456",:user_affirm=>params[:message])
    #    end
    if params[:login]==1
      @info=params[:textarea].split(";")
      @info.each do |info|
        @textarea=info.split(",")
        @user=User.new(:name=>@textarea[0],:username=>@textarea[0],:email=>@textarea[2],:mobilephone=>@textarea[1],:password=>"123456",:password_confirmation=>"123456")
        @user.status = User::STATUS[:NORMAL]
        @user.encrypt_password
        @user.save!
        ExamUser.create!(:user_id=>@user.id,:examination_id=>params[:id],:password=>"123456",:user_affirm=>params[:message])
      end
      if params[:exam_code]==1
        Examination.find(cookies[:examination_id]).update_attributes(:exam_password1=>proof_code(6),:exam_password2=>proof_code(6))
      end
   
    else
      @info_class=get_text(params[:user_info])
      i=0
      (0..@info_class.length/3-1).each do
        @user=User.new(:name=>@info_class[i],:username=>@info_class[i],:email=>@info_class[i+1],:mobilephone=>@info_class[i+2],:password=>"123456",:password_confirmation=>"123456",:status=>1)
        @user.encrypt_password
        puts @user.id
        ExamUser.create!(:user_id=>@user.id,:examination_id=>cookies[:examination_id],:password=>"123456",:user_affirm=>params[:message])
        i +=3
      end
      if params[:exam_code]==1
        Examination.find(cookies[:examination_id]).update_attributes(:exam_password1=>proof_code(6),:exam_password2=>proof_code(6))
      end
    end
    if params[:buttonvalue]=="保存"
      redirect_to "/exam_users/new_exam_two"
    else
      redirect_to "/exam_raters/new_exam_three"
    end
  end

  def destroy
    exam_user = ExamUser.find(params[:id].to_i)
    exam_user.destroy
    @examination = Examination.find(exam_user.examination_id)
    @exam_users =ExamUser.paginate_exam_user(exam_user.examination_id, 1, params[:page])
    render :partial=>"/examinations/exam_user_for_now"
    #    render :inline => ""
  end
  def edit
    @exam_user =ExamUser.find(params[:id].to_i)
    @user=User.find(ExamUser.find(params[:id].to_i).user_id)
    render :partial=>"/examinations/edit_exam_user"
  end

  def update_exam_user
    @exam_user =ExamUser.find(params[:id].to_i)
    @user=User.find(ExamUser.find(params[:id].to_i).user_id)
    @user.update_attributes(:name=>params[:name],:username=>params[:name],:email=>params[:email],
      :mobilephone=>params[:mobilephone])
    render :partial=>"/examinations/back_exam_user"
  end
  def my_results
    @exam_user=ExamUser.find_by_user_id(cookies[:user_id])
    sql = ExamUser.generate_result_sql
    sql += " and e.id in ( select u.examination_id from exam_users u where u.user_id=#{cookies[:user_id]}) and u.user_id=#{cookies[:user_id]} "
    @results=Examination.paginate_by_sql(sql,:per_page => 2, :page => params[:page])
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
  def search_list
    @exam_user=ExamUser.find_by_user_id(cookies[:user_id])
    sql = ExamUser.generate_result_sql
    sql += " and e.id in ( select u.examination_id from exam_users u where u.user_id=#{cookies[:user_id]}) and u.user_id=#{cookies[:user_id]}"
    sql += " and e.start_at_time >= '#{session[:start_at]}'" unless session[:start_at].nil?
    sql += " and e.start_at_time <= '#{session[:end_at]}'" unless session[:end_at].nil?
    sql += " and e.title like '%#{session[:title]}%'" unless session[:title].nil?
    @results = Examination.paginate_by_sql(sql, :pre_page => 1, :page => params[:page])
    render "my_results"
  end
end
