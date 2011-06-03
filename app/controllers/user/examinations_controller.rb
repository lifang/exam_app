class User::ExaminationsController < ApplicationController
  
  before_filter :access?
  
  def index
    @examinations = Examination.return_examinations(cookies[:user_id])
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
      #render :inline => "<iframe src='#{Constant::SERVER_PATH}/user/examinations/do_exam?url=#{url}' frameborder='0' style='width: 100%; height: 100%'></iframe>"
    else
      flash[:notice] = arr[0]
      redirect_to request.referer
    end
    
  end

  def do_exam


  end

end
