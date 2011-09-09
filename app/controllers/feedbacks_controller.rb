# encoding: utf-8
class FeedbacksController < ApplicationController
  def index
    @feedbacks=Feedback.paginate_by_sql("select * from feedbacks f order by f.status,  f.created_at",:per_page =>10, :page => params[:page])
  end


  def edit
    @feedback = Feedback.find(params[:id])
    @question = Question.find(@feedback.question_id)
    @problem = Problem.find(@question.id)
  end

  def update
    @feedback = Feedback.find(params[:id])
    @feedback.answer = params[:feedback]
    @feedback.status = Feedback::STATUS[:SOLVED]
    @feedback.save
    redirect_to "/feedbacks"
  end
end
