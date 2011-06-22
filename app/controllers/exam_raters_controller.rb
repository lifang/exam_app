class ExamRatersController < ApplicationController
  def create_exam_rater #创建阅卷老师
    @examination = Examination.find(params[:examination_id].to_i)
    @rater=ExamRater.find_by_email_and_examination_id(params[:exam_rater_infoemail],params[:examination_id])
    if @rater.nil?
      exam_rater=ExamRater.create!(:examination_id => @examination.id , :name => params[:exam_rater_infoname],
        :mobilephone => params[:exam_rater_infomobile], :email => params[:exam_rater_infoemail], :author_code => proof_code(6))
      UserMailer.rater_affirm(exam_rater,@examination).deliver
      @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
        :per_page => 5, :page => params[:page])
    else
      flash[:error]="信息已加入"
    end
    render :partial => "/examinations/exam_rater"
  end

  def destroy  #删除阅卷老师
    @exmination_id=ExamRater.find(params[:id].to_i).examination_id
    ExamRater.delete(params[:id].to_i)
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@exmination_id}",
      :per_page => 10, :page => params[:page])
    @examination=Examination.find(@exmination_id)
    render :partial=>"/examinations/exam_rater"
  end
  def edit  #阅卷老师信息编辑
    @exam_rater =ExamRater.find(params[:id].to_i)
    render :partial=>"/examinations/edit_exam_rater"
  end
  def update_exam_rater #更新阅卷老师信息
    @exam_rater =ExamRater.find(params[:id].to_i)
    @exam_rater.update_attributes(:name=>params[:name],:email=>params[:email],:mobilephone=>params[:mobilephone])
    render :partial=>"/examinations/back_exam_rater"
  end
  def login_rater
    @examination = Examination.find(params[:id].to_i)
    @info_raters = get_text(params[:rater_info].strip)
    str="阅卷老师重复的信息："
    str += ExamRater.check_rater(@info_raters,params[:id].to_i)
    if str=="阅卷老师重复的信息："
      ExamRater.create_raters(@info_raters,@examination)
      render :text =>"阅卷老师信息都已成功加入"
    else
      render :text => "<font color='blue'>#{str}</font>"
    end
  end
 
end
