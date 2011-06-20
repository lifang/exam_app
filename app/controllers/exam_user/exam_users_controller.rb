class ExamUser::ExamUsersController < ApplicationController
  require 'rexml/document'
  include REXML
  def show  #考试成绩显示
    exam=ExamUser.find_by_user_id_and_examination_id(cookies[:user_id],params[:id])
    answer=ExamRater.open_file("/result/#{exam.id}.xml")
    @doc=Document.new(answer).root
    file = ExamRater.open_file("/papers/#{exam.paper_id}.xml")
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