class PaperBlocksController < ApplicationController

  def choose_type
    @block_id = params[:id]
    @paper_id = params[:paper_id]
    @problem_type = params[:problem_type].to_i
    @question_type = params[:question_type].to_i
    if @question_type == Problem::QUESTION_TYPE[:SINGLE_CHOSE]
      render :partial => "/common/single_choose"
    elsif @question_type == Problem::QUESTION_TYPE[:MORE_CHOSE]
      render :partial => "/common/more_choose"
    elsif @question_type == Problem::QUESTION_TYPE[:JUDGE]
      render :partial => "/common/judge"
    elsif @question_type == Problem::QUESTION_TYPE[:SINGLE_CALK]
      render :partial => "/common/fill_blank"
    elsif @question_type == Problem::QUESTION_TYPE[:COLLIGATION]
      render :partial => "/common/colligation"
    else 
      render :partial => "/common/fill_blank"
    end

  end
  
end
