class ExamUsersController < ApplicationController
  before_filter :access?
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
    str = "发现考生信息重复或邮箱已被占用："
    str+=ExamUser.judge(@info_class,params[:id].to_i)
    if str=="发现考生信息重复或邮箱已被占用："
      ExamUser.login(@info_class,@examination)
      @exam_users = ExamUser.paginate_exam_user(@examination.id, 10, params[:page])
      flash[:notice] = "导入学生成功。"
      render :update do |page|
        page.replace_html "exam_user_list" , :partial => "/examinations/exam_user_for_now"
        page.replace_html "add_failed" ,  :inline => "<script>change_div_status();</script>"
      end
    else
      render :update do |page|
        page.replace_html "add_failed" ,  :text => "<font color='blue'>#{str}</font>"
      end
    end
  end

  def destroy #删除考生
    exam_user = ExamUser.find(params[:id].to_i)
    exam_user.destroy
    @examination = Examination.find(exam_user.examination_id)
    @exam_users =ExamUser.paginate_exam_user(exam_user.examination_id, 10, params[:page])
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

end
