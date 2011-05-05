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
    @paper=Paper.find(params[:question][:paper_id])
    @paper.update_attributes(:updated_at=>Time.now)
    redirect_to  "/papers/#{params[:question][:paper_id]}/new_step_two"
  end

  def edit
    @question=Question.find(params[:question][:paper_id])
    @question.update_attributes(:title=>params[:question][:title])
    @question_point=QuestionPoint.find(params[:question][:block_id])
    @question_point.update_attributes(:answer=>params[:question][:answer])
    QuestionAttr.find(params[:question][:attr_ids][0])
    redirect_to  "/papers/#{params[:question][:paper_id]}/new_step_two"

   
    
  end

  def  destroy
    @question=Question.find(params[:id])
    @question.destroy
    redirect_to request.referrer
  end
end
