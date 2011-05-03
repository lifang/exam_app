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
end
