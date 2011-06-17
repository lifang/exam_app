class ExamUser::ExamUsersController < ApplicationController
  require 'rexml/document'
  include REXML
  def pile_exam_users  #批量添加考生信息按钮
    @examination=Examination.find(params[:id])
    render :partial=>"/exam_users/pile_exam_users"
  end
  def single_user  #考生信息按钮
    @examination = Examination.find(params[:id].to_i)
    @exam_users = ExamUser.paginate_exam_user(@examination.id, 1,params[:page])
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
      :per_page => 1, :page => params[:page])
    @score_levels=@examination.score_levels
    render :partial=>"/examinations/exam_user_for_now"
  end
  def show  #考试成绩显示
    exam=ExamUser.find_by_user_id_and_examination_id(cookies[:user_id],params[:id])
    answer=File.open("#{Rails.root}/public/result/#{exam.id}.xml")
    @doc=Document.new(answer).root
    file = File.open("#{Constant::PAPER_PATH}/#{exam.paper_id}.xml")
    @xml=Document.new(file).root
    @xml.elements["blocks"].each_element do  |block|
      block.elements["problems"].each_element do |problem|
        problem.elements["questions"].each_element do |question|
          @doc.elements["paper"].elements["questions"].each_element do |element|
            if element.attributes["id"]==question.attributes["id"]
              question.add_attribute("user_answer","#{element.elements["answer"].text}")
              question.add_attribute("user_score","#{element.attributes["score"]}")
            end
          end
        end
      end
    end
  end

end