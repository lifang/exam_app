class BackController < ApplicationController

  def paper
    
  end

  def create
    paper=Paper.create(params[:paper])
    PaperBlock.create(:paper_id=>paper.id)
  end

end
