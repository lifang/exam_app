class QuestionsController < ApplicationController
  def new
  end

  def create
    
    @question=Question.create(:title=>params[:question][:title])
    BlockQuestionRelation.create(:question_id=>@question.id,:paper_block_id=>params[:question][:block_id],:score=>params[:question][:score],:assess_role=>params[:question][:assess_role])
    @question_point=QuestionPoint.create(:question_id=>@question.id,:answer=>params[:question][:answer])
    QuestionAttr.create(:question_point_id=>@question_point.id,:key=>params[:question][:attr1_key],:value=>params[:question][:attr1_value])
    QuestionAttr.create(:question_point_id=>@question_point.id,:key=>params[:question][:attr2_key],:value=>params[:question][:attr2_value])
    QuestionAttr.create(:question_point_id=>@question_point.id,:key=>params[:question][:attr3_key],:value=>params[:question][:attr3_value])
    QuestionAttr.create(:question_point_id=>@question_point.id,:key=>params[:question][:attr4_key],:value=>params[:question][:attr4_value])
    redirect_to  "/papers/#{params[:question][:paper_id]}/new_step_two"
  end

  def  destory
    
  end
end