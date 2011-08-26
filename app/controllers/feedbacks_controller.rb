class FeedbacksController < ApplicationController
  def index
    @feedbacks=Feedback.all
  end

  def create
    @feedback=Feedback.new(:description=>params[:feedback][:description],:answer=>params[:feedback][:answer],:user_id=>"#{cookies[:user_id]}")
    if @feedback.save
      redirect_to "/feedbacks"
    end
  end

  def edit
    @feedback = Feedback.find(params[:id])
  end

  def update
    @feedback = Feedback.find(params[:id])
    if @feedback.update_attributes(params[:feedback])
      redirect_to "/feedbacks"
    end
  end
end