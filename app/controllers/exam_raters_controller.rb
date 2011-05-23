class ExamRatersController < ApplicationController
  def new_exam_three
   
  end

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
    ExamRater.delete(params[:id].to_i)
    render :inline => ""
  end

end
