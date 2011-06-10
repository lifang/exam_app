class Rater::ExamRatersController < ApplicationController
  layout "rater"
  require 'rexml/document'
  include REXML
  def rater_session
    @rater=ExamRater.find(params[:id])
    @examination=Examination.find(params[:examination])
    render "/rater/exam_raters/session"
  end
  def rater_login
    @rater=ExamRater.find(params[:id])
    @examination=Examination.find(params[:examination_id])
    if @rater.author_code==params[:author_code]
      cookies[:rater_id]=@rater.id
      cookies[:examination_id]=@examination.id
      flash[:success]="登陆成功"
      @exam_paper_total=ExamUser.find_by_sql("select * from exam_users eu where eu.examination_id=
     #{params[:examination_id]} and eu.answer_sheet_url  is not null")
      @exam_score_total=ExamUser.find_by_sql("select e.id from exam_users e left join rater_user_relations r on r.exam_user_id= e.user_id  where e.examination_id=#{ cookies[:examination_id]} and r.is_marked is null ")
      @exam_paper_marked=ExamUser.find_by_sql("select e.id from exam_users e left join rater_user_relations r on r.exam_user_id=
                         e.user_id  where e.examination_id=#{ cookies[:examination_id]} and r.is_marked is not null ")
      render "/rater/exam_raters/reader_papers"
    else
      flash[:error]="阅卷码不正确，请核对！"
      render "/rater/exam_raters/session"
    end
  end
  def check_paper
    exam_users=ExamUser.find_by_sql("select e.id from exam_users e left join rater_user_relations r on r.exam_user_id=
                         e.user_id  where e.examination_id=#{ cookies[:examination_id]} and r.is_marked is null")
    @exam_user=exam_users[rand(exam_users.length)].id
    ExamUser.find(@exam_user).update_attributes(:total_score=>0)
    RaterUserRelation.create(:exam_rater_id=>cookies[:rater_id],:exam_user_id=>@exam_user)
    redirect_to "/rater/exam_raters/#{@exam_user}/answer_paper"
  end
  def answer_paper
    @exam_user=ExamUser.find(params[:id])
    @url="#{Rails.root}/public"+@exam_user.answer_sheet_url
    file = File.open(@url)
    @doc=Document.new(file).root
    file1=File.open("#{Rails.root}/public/papers/#{ @doc.elements[1].attributes["id"]}.xml")
    @xml=Document.new(file1).root
    #    @xml.elements["blocks"].each_element {|element|  element.elements["problems"].each_element {|element1| puts element1.attributes["id"]};print "end";}
  end
  def get_score
    url="#{Rails.root}/public/result/#{params[:answer_id]}.xml"
    file=File.open(url)
    doc=Document.new(file).root
    file1=File.open("#{Rails.root}/public/papers/#{ doc.elements[1].attributes["id"]}.xml")
    @xml=Document.new(file1).root
    doc.elements[1].elements[1].each_element do |element|
      if element.attributes["id"]==params[:problem_id]
        element.add_attribute("score","#{params[:single_value]}")
      end
    end
    doc.to_s
    file = File.new(url, "w+")
    file.write(doc)
    file.close
    redirect_to "/rater/exam_raters/#{params[:answer_id]}/answer_paper"
  end
end
