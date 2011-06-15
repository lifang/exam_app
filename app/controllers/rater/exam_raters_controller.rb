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
    @exam_paper_total=ExamUser.find_by_sql("select * from exam_users eu where eu.examination_id=
     #{@examination.id} and eu.answer_sheet_url is not null")
    @exam_score_total=ExamUser.find_by_sql("select * from exam_users e left join rater_user_relations r on r.exam_user_id= e.id  where e.examination_id=#{params[:id]} and e.answer_sheet_url is not null and r.id is null ")
    @exam_paper_marked=ExamUser.find_by_sql("select * from exam_users e left join rater_user_relations r on r.exam_user_id=
                         e.id  where e.examination_id=#{params[:id]} and r.is_marked=1 and e.answer_sheet_url is not null")
  end
  def check_paper  #选择要批阅的答卷
    exam_users=ExamUser.find_by_sql("select e.id from exam_users e left join rater_user_relations r on r.exam_user_id=e.id  where e.examination_id=#{cookies[:examination_id]} and r.id is null and e.answer_sheet_url is not null")
    puts exam_users
    @exam_user=exam_users[rand(exam_users.length)].id
    RaterUserRelation.create(:exam_rater_id=>cookies[:rater_id],:exam_user_id=>@exam_user)
    redirect_to "/rater/exam_raters/#{@exam_user}/answer_paper"
  end
  def answer_paper #批阅答卷
    @exam_user=ExamUser.find(params[:id])
    @url="#{Rails.root}/public"+@exam_user.answer_sheet_url
    file = File.open(@url)
    @doc=Document.new(file).root
    file1=File.open("#{Rails.root}/public/papers/#{ @doc.elements[1].attributes["id"]}.xml")
    @xml=Document.new(file1).root
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
    puts @xml
  end
  def over_answer #批阅完成，给答卷添加成绩
    @exam_relation=RaterUserRelation.find_by_exam_user_id(params[:id])
    @exam_relation.is_marked=true
    @exam_relation.update_attributes(:is_marked=>1)
    url="#{Rails.root}/public/result/#{params[:id]}.xml"
    file=File.open(url)
    doc=Document.new(file).root
    doc.elements[1].elements[1].each_element do |element|
      element.add_attribute("score","#{params["single_value_#{element.attributes["id"]}"]}")
    end
    score=0
    doc.elements[1].elements[1].each_element do |element|
      score +=element.attributes["score"].to_i
    end
    doc.elements[1].add_attribute("rater_score","#{score}")
    doc.to_s
    self.write_xml(url, doc)
    redirect_to "/rater/exam_raters/#{ExamUser.find(params[:id]).examination_id}/reader_papers"
  end
end
