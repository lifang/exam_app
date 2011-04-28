class PagesController < ApplicationController
  def index
     
  end
  def show
    @paper=Paper.find(1)
    @block1=@paper.paper_blocks.find(1)
    @block2=@paper.paper_blocks.find(3)
  end
end
