class PagesController < ApplicationController
before_filter :access?
  def index
     flash[:notice] = "ssdfsfsfs"
  end

  def show
   
  end

  def create_step_one

  end

  def create_step_two

  end
  def create_exam_one
    
  end
  def create_exam_three
    
  end
end
