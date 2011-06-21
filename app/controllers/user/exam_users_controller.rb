class User::ExamUsersController < ApplicationController
  require 'rexml/document'
  include REXML
  def show
    @exam=ExamUser.find_by_user_id_and_examination_id(params[:user_id],params[:id])
    @doc=ExamRater.open_file("/result/#{@exam.id}.xml")
    @xml=ExamUser.show_result(@exam.paper_id, @doc)
  end

  def edit_score
    url="/result/#{params[:user_id]}.xml"
    doc=ExamRater.open_file(url)
    doc.elements["paper"].elements["questions"].each_element do |question|
      if question.attributes["id"]==params[:id]
        exam_user=ExamUser.find(params[:user_id])
        exam_user.total_score += (params[:score].to_i-question.attributes["score"].to_i )
        doc.elements["paper"].attributes["score"]=exam_user.total_score
        exam_user.save
        question.attributes["score"]=params[:score]
      end
    end
    self.write_xml("#{Rails.root}/public"+url, doc)
    render :inline => ""
  end

  def my_results   #考生成绩
    @exam_user=ExamUser.find_by_user_id(cookies[:user_id])
    sql = ExamUser.generate_result_sql
    sql += " and us.id=#{cookies[:user_id]} "
    @results=Examination.paginate_by_sql(sql,:per_page =>10, :page => params[:page])
  end


  def search
    session[:start_at] = nil
    session[:end_at] = nil
    session[:title] = nil
    session[:start_at] = params[:start_at] if !params[:start_at].nil? and params[:start_at] != ""
    session[:end_at] = params[:end_at] if !params[:end_at].nil? and params[:end_at] != ""
    session[:title] = params[:title] if !params[:title].nil? and params[:title] != ""
    redirect_to "/user/exam_users/search_list"
  end

  def search_list #成绩查询
    @exam_user=ExamUser.find_by_user_id(cookies[:user_id])
    sql = ExamUser.generate_result_sql
    sql += " and us.id=#{cookies[:user_id]}"
    sql += " and e.start_at_time >= '#{session[:start_at]}'" unless session[:start_at].nil?
    sql += " and e.start_at_time <= '#{session[:end_at]}'" unless session[:end_at].nil?
    sql += " and e.title like '%#{session[:title]}%'" unless session[:title].nil?
    @results = Examination.paginate_by_sql(sql, :pre_page => 10, :page => params[:page])
    render "my_results"
  end
  
end
