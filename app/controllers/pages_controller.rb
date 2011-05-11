class PagesController < ApplicationController

  def index
    
  end

  def show
   
  end

  def rater_login
    render :layout => "rater"
  end

  def paper_list
    render :layout => "rater"
  end

  def rate_paper
    render :layout => "rater"
  end

  def exam_query_login
    render :layout => "common"
  end

  def my_results_simple
    render :layout => "common"
  end

  def user_exams
    render :layout => "common"
  end
end


