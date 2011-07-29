class ItemPoolsController < ApplicationController


    def index
      @problems = Problem.search_mothod( nil, nil, nil, nil, 10, params[:page])
    end

    def index_search
      #@problems = Problem.search_mothod( nil, nil, nil, nil, 10, params[:page])
      render 'index'
    end

end
