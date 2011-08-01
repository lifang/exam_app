class ItemPoolsController < ApplicationController



  def create_paper
    @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:title].strip,
      :description=>params[:description].strip, :category_id => params[:category])
    category = Category.find(params[:category].to_i)
    @paper.create_paper_url(@paper.xml_content({"category_name" => category.name}), "papers", "xml") unless category.nil?
    redirect_to "/item_pools/#{@paper.id}/new_step_two"
  end

  def index
    @problems = Problem.search_mothod(nil,nil,nil,nil,20, params[:page])
  end

  def index_search
    @problems = Problem.search_mothod(params[:mintime],params[:maxtime],params[:category],params[:type], 20, params[:page])
    render 'index'
  end


end
