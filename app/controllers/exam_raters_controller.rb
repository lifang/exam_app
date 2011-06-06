class ExamRatersController < ApplicationController
  def create_exam_rater
    @examination = Examination.find(params[:examination_id].to_i)
    @rater=ExamRater.find_by_sql("select u.id from exam_raters u where u.name='#{params[:infoname]}'
         and u.email='#{params[:infoemail]}' and u.examination_id=#{params[:examination_id].to_i} ")
    if (@examination  and !@rater.nil? )
      exam_rater=ExamRater.create!(:examination_id => @examination.id , :name => params[:infoname],
        :mobilephone => params[:infomobile], :email => params[:infoemail], :author_code => proof_code(6))
      UserMailer.rater_affirm(exam_rater,@examination).deliver
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
  def rater_session
    @rater=ExamRater.find(params[:id])
    @examination=Examination.find(params[:examination])
    render "/exam_raters/session"
  end
  def rater_login
    @rater=ExamRater.find(params[:id])
    @examination=Examination.find(params[:examination_id])
    if @rater.author_code==params[:author_code]
      cookies[:rater_id]=@rater.id
      flash[:success]="登陆成功"
      render "/exam_raters/reader_papers"
    else
      flash[:error]="阅卷码不正确，请核对！"
      render "/exam_raters/session"
    end

  end
end
