class QuestionsController < ApplicationController

  require 'rexml/document'
  include REXML

  def edit_question
    doc=Document.new(File.open "#{PAPER_PATH}/#{params[:paper_id].to_i}.xml")
    question = doc.elements["#{params[:xpath]}"]
    render :partial => "/common/edit_other_question", :object => question
  end

  def destroy
    @question=Question.find(params[:id])
    @question.destroy
    redirect_to request.referrer
  end
  
end
