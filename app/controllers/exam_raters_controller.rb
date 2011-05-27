class ExamRatersController < ApplicationController
  def create_exam_rater
    @examination = Examination.find(params[:examination_id].to_i)
    if @examination
      ExamRater.create!(:examination_id => @examination.id , :name => params[:infoname],
        :mobilephone => params[:infomobile], :email => params[:infoemail], :author_code => proof_code(6))
      @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
        :per_page => 1, :page => params[:page])
    end
    render :partial => "/examinations/exam_rater"
  end

  def destroy
    @exmination_id=ExamRater.find(params[:id].to_i).examination_id
    ExamRater.delete(params[:id].to_i)
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@exmination_id}",
      :per_page => 1, :page => params[:page])
    @examination=Examination.find(@exmination_id)
    render :partial=>"/examinations/exam_rater"
    #    render :inline => ""
  end
  def edit
    @exam_rater =ExamRater.find(params[:id].to_i)
    render :partial=>"/examinations/edit_exam_rater"
  end
  def update_exam_rater
    @exam_rater =ExamRater.find(params[:id].to_i)
    @exam_rater.update_attributes(:name=>params[:name],:email=>params[:email],:mobilephone=>params[:mobilephone])
    render :partial=>"/examinations/back_exam_rater"
  end
end
