class ExamUsersController < ApplicationController
  
  #单个添加考生
  def create_exam_user  
    @examination = Examination.find(params[:examination_id].to_i)
    user = User.find_by_email(params[:exam_user_infoemail].strip)
    if user
      if user.name == params[:exam_user_infoname].strip
        if ExamUser.find_by_examination_id_and_user_id(params[:examination_id].to_i, user.id)
          flash[:error]="该考生信息已加入"
        else
          @examination.new_exam_user(user)
        end
      else
        flash[:error]="该邮箱已经被其他用户使用"
      end
    else
      user = User.auto_add_user(params[:exam_user_infoname].strip, params[:exam_user_infoname].strip,
        params[:exam_user_infoemail].strip, params[:exam_user_infomobile])
      @examination.new_exam_user(user)
    end
    @exam_users = ExamUser.paginate_exam_user(@examination.id, 10, params[:page])
    render :partial => "/examinations/exam_user_for_now"
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
    @info_class = get_text(params[:user_info].strip)
    i=0
    str = "发现信息重复加入的考生："
    str1 = "发现邮箱已被占用："
    (0..@info_class.length/3-1).each do
      user = User.find_by_email(@info_class[i+2].strip)
      if user
        if user.name == @info_class[i+1].strip
          if ExamUser.find_by_examination_id_and_user_id(params[:examination_id].to_i, user.id)
            flash[:error] = str + @info_class[i] + "," + @info_class[i+1] + ";"
          else
            @examination.new_exam_user(user)
          end
        else
          flash[:error] = str1 + @info_class[i] + "," + @info_class[i+1] + ";"
        end
      else
        user = User.auto_add_user(@info_class[i].strip, @info_class[i].strip, @info_class[i+1].strip, @info_class[i+2])
        @examination.new_exam_user(user)
      end
      i +=3
    end
    if str=="发现信息重复加入的考生：" && str1=="发现邮箱已被占用："
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
    @results=Examination.paginate_by_sql(sql,:per_page =>10, :page => params[:page])
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

end
