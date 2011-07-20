class ExamRatersController < ApplicationController
  before_filter :access?
  
  def create_exam_rater #创建阅卷老师
    @examination = Examination.find(params[:examination_id].to_i)
    rater=ExamRater.find_by_email_and_examination_id(params[:exam_rater_infoemail],params[:examination_id])
    if rater
      flash[:error]="信息已加入"
    else
      @exam_rater=ExamRater.create!(:examination_id => @examination.id , :name => params[:exam_rater_infoname],
        :mobilephone => params[:exam_rater_infomobile], :email => params[:exam_rater_infoemail], :author_code => proof_code(6))
      UserMailer.rater_affirm(@exam_rater,@examination).deliver
    end
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
      :per_page => 10, :page => params[:page])
    @exam_all={}
    @relations=RaterUserRelation.find_by_sql("select sum(rate_time) long_time, count(id) sum,exam_rater_id rater_id from rater_user_relations group by exam_rater_id")
    @relations.collect() { |exam_rater| @exam_all["#{exam_rater.rater_id}"]=exam_rater }
    render :partial => "/examinations/exam_rater"
  end

  def destroy  #删除阅卷老师
    @exmination_id=ExamRater.find(params[:id].to_i).examination_id
    ExamRater.delete(params[:id].to_i)
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@exmination_id}",
      :per_page => 10, :page => params[:page])
    @exam_all={}
    @relations=RaterUserRelation.find_by_sql("select sum(rate_time) long_time, count(id) sum,exam_rater_id rater_id from rater_user_relations group by exam_rater_id")
    @relations.collect() { |exam_rater| @exam_all["#{exam_rater.rater_id}"]=exam_rater }
    @examination=Examination.find(@exmination_id)
    render :partial=>"/examinations/exam_rater"
  end

  def edit  #阅卷老师信息编辑
    @exam_rater =ExamRater.find(params[:id].to_i)
    render :partial=>"/examinations/edit_exam_rater"
  end

  def update_exam_rater #更新阅卷老师信息
    @exam_rater =ExamRater.find(params[:id].to_i)
    rater=ExamRater.find_by_email_and_examination_id(params[:email],@exam_rater.examination_id)
    if rater
      if @exam_rater.email == params[:email]
        @exam_rater.update_attributes(:name=>params[:name],:email=>params[:email],:mobilephone=>params[:mobilephone])
      else
        flash.now[:error]="be_used"
      end
    else
      @exam_rater.update_attributes(:name=>params[:name],:email=>params[:email],:mobilephone=>params[:mobilephone])
    end
    render :partial=>"/examinations/back_exam_rater"
  end
  
  def login_rater
    @examination = Examination.find(params[:id].to_i)
    @info_raters = get_text(params[:rater_info].strip)
    str="阅卷老师重复的信息："
    str += ExamRater.check_rater(@info_raters,params[:id].to_i)
    if str=="阅卷老师重复的信息："
      ExamRater.create_raters(@info_raters,@examination)
      @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
        :per_page => 10, :page => params[:page])
      flash[:notice] = "导入信息成功。"
      render :update do |page|
        page.replace_html "exam_rater_list" , :partial => "/examinations/exam_rater"
        page.replace_html "add_info" ,  :inline => "<script>show_name('exam_rater_list','pile_exam_rater');</script>"
      end
    else
      render :update do |page|
        page.replace_html "add_info" ,  :text => "<font color='blue'>#{str}</font>"
      end
    end
  end

  def accept_score
    @rater_relations=RaterUserRelation.find_by_sql("select * from rater_user_relations r where r.exam_rater_id=#{params[:id]} and r.is_authed = 0")
    unless @rater_relations.blank?
      @rater_relations.each do |rater_relation|
        rater_relation.toggle!(:is_authed)

    end
     flash[:success]="当前老师批改的成绩认可成功。"
    else
      flash[:warn]="当前老师没有新批改试卷。"
    end
    redirect_to request.referer
  end
  def cancel_score
    @rater_relations=RaterUserRelation.find_all_by_exam_rater_id(params[:id])
    @rater_relations.each do |rater_relation|
      unless rater_relation.is_authed ==true
        ExamUser.find(rater_relation.exam_user_id).update_attributes(:total_score=>0)
        rater_relation.destroy
      end
    end
    flash[:notice]="当前老师批改的成绩已经作废。"
    redirect_to request.referer
  end

  def random_paper
    @rater=ExamRater.find(params[:id])
    @examination=Examination.find(@rater.examination_id)
    @exam_users=ExamUser.find_by_sql("select eu.* from exam_users eu inner join rater_user_relations r on r.exam_user_id = eu.id
      where eu.examination_id = #{@examination.id} and r.is_authed=0 and r.is_checked=0 order by rand() limit 1")
    unless @exam_users.blank?
      @exam_user=@exam_users[0]
      RaterUserRelation.find_by_exam_user_id(@exam_user.id).update_attributes(:is_checked=>true)
      doc=ExamRater.open_file(@exam_user.answer_sheet_url)
      xml=ExamRater.open_file("/papers/#{doc.elements[1].attributes["id"]}.xml")
      @xml=ExamUser.answer_questions(xml,doc)
    else
      flash[:warn] = "当前老师没有新批改试卷。"
      redirect_to examination_path(@examination)
    end
  end
end
