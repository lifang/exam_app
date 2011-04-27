class PapersController < ApplicationController
  def show
    @paper=Paper.find(params[:id])

  end

  def edit

  end
  def index
     @papers=User.find(params[:id]).papers
  end
end
