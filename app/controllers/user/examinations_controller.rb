class User::ExaminationsController < ApplicationController
  #layout "paper", :only => [:show, :save_result]
  before_filter :access?
  
  def index
    @examinations = Examination.return_examinations(cookies[:user_id])
    #render :layout => "application"
  end

  def show

    arr = Examination.can_answer(cookies[:user_id], params[:id].to_i)
    if arr[0] == "" and arr[1].any?
      @examination = arr[1][0]
      @paper_url = "#{Constant::PAPER_CLIENT_PATH}/#{@examination.paper_id}.js"
      if @examination.started_at.nil? or @examination.started_at == ""
        @exam_user = ExamUser.find(@examination.exam_user_id)
        @exam_user.update_info_for_join_exam(@examination.start_at_time, @examination.exam_time)
      end
      #render :inline => "<iframe src='#{Constant::SERVER_PATH}/user/examinations/do_exam?url=#{url}'
      #frameborder='0' style='width: 100%; height: 100%'></iframe>"
    else
      flash[:warn] = arr[0]
      redirect_to request.referer
    end
    
  end

  def save_result
    @exam_user = ExamUser.find_by_examination_id_and_user_id(params[:id], cookies[:user_id])
    if @exam_user and (@exam_user.is_submited.nil? or @exam_user.is_submited == false)
      question_hash = {}
      question_ids = params[:all_quesiton_ids].split(",") if params[:all_quesiton_ids]
      question_ids.each do |question_id|
        question_hash[question_id] = params["answer_" + question_id]
      end if question_ids
      @exam_user.generate_answer_sheet_url(@exam_user.update_answer_url(question_hash), "result")
      @exam_user.submited!
      flash[:notice] = "您的试卷已经成功提交。"
    else
      flash[:warn] = "您已经交卷。"
      render "error_page"
    end
  end

  def error_page
    
  end

end
