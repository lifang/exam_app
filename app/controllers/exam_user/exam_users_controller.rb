class ExamUser::ExamUsersController < ApplicationController
  def pile_exam_users
     @examination=Examination.find(params[:id])
    render :partial=>"/exam_users/pile_exam_users"
  end
  def single_user
    @examination = Examination.find(params[:id].to_i)
    @exam_users = ExamUser.paginate_exam_user(@examination.id, 1,params[:page])
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
      :per_page => 1, :page => params[:page])
    @score_levels=@examination.score_levels
    render :partial=>"/examinations/exam_user_for_now"
  end


end