class User::ExaminationsController < ApplicationController
  before_filter :access?
  
  def index
    @examinations = Examination.all_examinations(cookies[:user_id])
  end

  def show
    @examination = Examination.find(params[:id].to_i)
   
    

  end

end
