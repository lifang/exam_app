class PagesController < ApplicationController
  def index
     params[:id]=1
      @papers=User.find(params[:id]).papers
  end
  def show
    
  end
end
