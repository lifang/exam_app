# encoding: utf-8
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
    @problems = Problem.search_mothod(nil,nil,nil,nil,10, params[:page])
  end

  def index_search
    @problems = Problem.search_mothod(params[:mintime],params[:maxtime],params[:category],params[:type],10, params[:page])
    unless params[:tags].nil?||params[:tags]==""
      tags = params[:tags].split(" ")
      in_condition = ""
      num=0
      tags.each do |tag|
        in_condition +="," if num!=0
        in_condition += "'"
        in_condition += tag.to_s
        in_condition += "'"
        num += 1
      end
      tags = Tag.where("name in (#{in_condition})")
      tag_sum = 0
      tags.each do |tag|
        tag_sum += tag.num
      end                           #取得标签的总和
      problem_array=[]
      @problems.each do |problem|
        if problem.total_num!=nil
          total_num=problem.total_num
          if tag_sum&total_num==tag_sum  
            problem_array << problem
          end
        end
      end
      @problems=problem_array.paginate(:page=>params[:page],:per_page=>10)
    end
    render 'index'
  end
  
end
