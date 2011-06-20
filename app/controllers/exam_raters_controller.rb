class ExamRatersController < ApplicationController
  def create_exam_rater #创建阅卷老师
    @examination = Examination.find(params[:examination_id].to_i)
    @rater=ExamRater.find_by_email_and_examination_id(params[:exam_rater_infoemail],params[:examination_id])
    if ( !@rater.nil? )
      exam_rater=ExamRater.create!(:examination_id => @examination.id , :name => params[:exam_rater_infoname],
        :mobilephone => params[:exam_rater_infomobile], :email => params[:exam_rater_infoemail], :author_code => proof_code(6))
      UserMailer.rater_affirm(exam_rater,@examination).deliver
      @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
        :per_page => 1, :page => params[:page])
    end
    render :partial => "/examinations/exam_rater"
  end

  def destroy  #删除阅卷老师
    @exmination_id=ExamRater.find(params[:id].to_i).examination_id
    ExamRater.delete(params[:id].to_i)
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@exmination_id}",
      :per_page => 1, :page => params[:page])
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
 
end
