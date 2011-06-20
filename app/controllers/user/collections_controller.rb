class User::CollectionsController < ApplicationController
  before_filter :access?
  
  def index
    
  end

  def create
    paper_id = params[:paper_id]
    examination_id = params[:examination_id]
    problem_id = params[:problem_id]
    exam_user = ExamUser.is_exam_user_in(paper_id, examination_id)
    if exam_user
      collection = Collection.find_by_user_id(exam_user.user_id)
      collection = Collection.generate_collection(cookies[:user_id]) if collection.nil?
      
    end
  end
  
end
