class PagesController < ApplicationController
  def index
    @papers=User.find(params[:id]).papers
  end
  def show
    @paper=Paper.find(1)
  end
end
