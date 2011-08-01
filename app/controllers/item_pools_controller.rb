class ItemPoolsController < ApplicationController
  require 'rexml/document'
  include REXML
  before_filter :access?

  def create_paper
    @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:title].strip,
      :description=>params[:description].strip, :category_id => params[:category])
    category = Category.find(params[:category].to_i)
    @paper.create_paper_url(@paper.xml_content({"category_name" => category.name}), "papers", "xml") unless category.nil?
    redirect_to "/item_pools/#{@paper.id}/revise_item"
  end

  def revise_item
    paper = Paper.find(params[:id].to_i)
    begin
      file = File.open("#{Constant::PUBLIC_PATH}#{paper.paper_url}")
      @xml=Document.new(file).root
    rescue
      flash[:error] = "当前试卷不能正常打开，请检查试卷是否正常。"
      redirect_to papers_path
    end
  end

  def new_module
    @block = PaperBlock.create(:paper_id => params[:module][:paper_id],
      :title => params[:module][:title],:description => params[:module][:description])
    @block.create_block_xml("#{Rails.root}/public" + @block.paper.paper_url)
    redirect_to request.referrer
  end

  def items_search
     
    render :partial=>"add_item"
  end

  def index
    @problems = Problem.search_mothod(nil,nil,nil,nil,20, params[:page])
  end

  def index_search
    @problems = Problem.search_mothod(params[:mintime],params[:maxtime],params[:category],params[:type], 20, params[:page])
    render 'index'
  end


end
