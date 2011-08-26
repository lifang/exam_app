class FeedbacksController < ApplicationController
  def index
    @feedbacks=Feedback.find_by_sql("select * from feedbacks f order by f.answer and f.created_at")
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