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
    doc.to_s
    self.write_xml("#{Rails.root}/public"+url, doc)
    render :inline=>"更新成功"
  end
  def exam_session
    @user = User.find_by_email(params[:session][:email])
    if @user.nil?
      flash[:error] = "邮箱不存在"
      redirect_to '/sessions/new'
    else
      unless  @user.has_password?(params[:session][:password])
        flash[:error] = "密码错误"
        redirect_to '/user/exam_users/session_new'
      else
        cookies[:exam_user_id]=@user.id
        redirect_to "/user/exam_users/"
      end
    end
  end
  def index
     @user=User.find(cookies[:exam_user_id])
    @exam_users=ExamUser.find_by_sql("select * from exam_users e where e.user_id=#{@user.id}")
  end
end
