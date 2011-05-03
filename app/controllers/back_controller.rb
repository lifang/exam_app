class BackController < ApplicationController
before_filter :access?
  def paper
    
  end

  def create
    paper=Paper.create(params[:paper])
    PaperBlock.create(:paper_id=>paper.id)
  end

end
