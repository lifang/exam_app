class PagesController < ApplicationController
  def index
        @papers=User.find(params[:id]).papers
  end
  def show
    
  end
end
