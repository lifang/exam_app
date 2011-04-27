class PagesController < ApplicationController
  def index
     params[:id]=1
      @papers=User.find(params[:id]).papers
  end
  def show
    @paper=Paper.find(1)
    @block1=@paper.paper_blocks.find(1)
    @block2=@paper.paper_blocks.find(3)
  end
end
