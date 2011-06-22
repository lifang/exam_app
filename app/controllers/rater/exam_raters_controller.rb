class Rater::ExamRatersController < ApplicationController
  layout "rater"
  require 'rexml/document'
  include REXML
  def rater_session #阅卷老师登陆页面
    @rater=ExamRater.find(params[:id])
    @examination=Examination.find(params[:examination])
    render "/rater/exam_raters/session"
  end
  
  def rater_login  #阅卷老师登陆
    @rater=ExamRater.find(params[:id])
    @examination=Examination.find(params[:examination_id])
    if @rater.author_code==params[:author_code]
      cookies[:rater_id]=@rater.id
      cookies[:examination_id]=@examination.id
      flash[:success]="登陆成功"
      redirect_to  "/rater/exam_raters/#{@examination.id}/reader_papers"
    else
      flash[:error]="阅卷码不正确，请核对！"
      render "/rater/exam_raters/session"
    end
  end
  
  def reader_papers  #答卷批阅状态显示
    @examination=Examination.find(params[:id])
    
    @exam_paper_total = ExamUser.find_by_sql("select e.id exam_user_id, r.id relation_id, r.is_marked from exam_users e
        left join rater_user_relations r on r.exam_user_id= e.id
        where e.examination_id=#{params[:id]} and e.answer_sheet_url is not null ")
    @exam_score_total = 0
    @exam_paper_marked = 0
    @exam_paper_total.each do |e|
     
    end unless @exam_paper_total.blank?

    sql1="and r.id is null"
    sql2="and r.is_marked=1"
    @exam_score_total=ExamUser.get_paper(params[:id],sql1)
    @exam_paper_marked=ExamUser.get_paper(params[:id],sql2)
  end
  
  def check_paper  #选择要批阅的答卷
    sql="and r.id is null "
    exam_users=ExamUser.get_paper(cookies[:examination_id],sql)
    @exam_user=exam_users[rand(exam_users.length)].id
    RaterUserRelation.create(:exam_rater_id=>cookies[:rater_id],:exam_user_id=>@exam_user)
    redirect_to "/rater/exam_raters/#{@exam_user}/answer_paper"
  end
  
  def answer_paper #批阅答卷
    @exam_user=ExamUser.find(params[:id])
    @doc=ExamRater.open_file(@exam_user.answer_sheet_url)
    @xml=ExamRater.open_file("/papers/#{@doc.elements[1].attributes["id"]}.xml")
    @str="-1"
    @xml.elements["blocks"].each_element do  |block|
      block.elements["problems"].each_element do |problem|
        if (problem.attributes["types"].to_i !=4&&problem.attributes["types"].to_i !=5)
          block.delete_element(problem.xpath)
        else
          problem.elements["questions"].each_element do |question|
            if question.attributes["correct_type"].to_i ==5
              @str += (","+question.attributes["id"])
            else
              problem.delete_element(question.xpath)
            end
          end
        end
        if problem.elements["questions"].elements[1].nil?
          block.delete_element(problem.xpath)
        end
      end
    end
    @xml.to_s
  end

  def over_answer #批阅完成，给答卷添加成绩
    @exam_relation=RaterUserRelation.find_by_exam_user_id(params[:id])
    @exam_relation.is_marked=true
    @exam_relation.update_attributes(:is_marked=>1)
    url="/result/#{params[:id]}.xml"
    doc=ExamRater.open_file(url)
    doc.elements[1].elements[1].each_element do |element|
      element.add_attribute("score","#{params["single_value_#{element.attributes["id"]}"]}")
    end
    score=0
    doc.elements[1].elements[1].each_element do |element|
      score +=element.attributes["score"].to_i
    end
    doc.elements["paper"].elements["rate_score"].text=score
    unless doc.elements[1].elements["auto_score"].nil?
      auto_score=doc.elements[1].elements["auto_score"].text
      if auto_score.to_i !=0
        ExamUser.find(params[:id]).update_attributes(:total_score=>score+auto_score.to_i)
      end
    end
    doc.to_s
    self.write_xml("#{Rails.root}/public"+url, doc)
    redirect_to "/rater/exam_raters/#{ExamUser.find(params[:id]).examination_id}/reader_papers"
  end

  def destroy
    cookies.delete(:rater_id)
    cookies.delete(:examination_id)
    render :inline=>"<script>window.close();</script>"
  end

  def show
    @exam_rater=ExamRater.find(params[:id])
  end

  def edit_value
    @exam_rater=ExamRater.find(params[:id])
    @exam_rater.update_attributes(:name=>params[:value])
    render :inline=>"姓&nbsp;&nbsp;&nbsp;&nbsp;名:#{ @exam_rater.name}"
  end
  
  def index
    @exam_rater=ExamRater.find(cookies[:rater_id])
    @exam_list=ExamRater.find_all_by_email(@exam_rater.email)
  end
end
