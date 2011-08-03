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
    @paper = Paper.find(params[:id].to_i)
    begin
      file = File.open("#{Constant::PUBLIC_PATH}#{@paper.paper_url}")
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
    @paper_id=params[:paper_id]
    url="#{Constant::PUBLIC_PATH}/papers/#{params[:paper_id]}.xml"
    file = File.open(url)
    doc=Document.new(file).root
    @id=params[:id]
    @problems=Problem.search_items_num(params[:item_tag],params[:item_style],params[:item_sort],doc.elements["problem_ids"].text)
    @condition="#{params[:item_tag]};#{params[:item_style]};#{params[:item_sort]}"
    render :partial=>"add_item"
  end

  def add_problems
    condition=params["condition#{params[:block_id]}"].split(";")
    @paper = Paper.find(params[:id].to_i)
    url="#{Constant::PUBLIC_PATH}#{@paper.paper_url}"
    file = File.open(url)
    doc=Document.new(file)
    @problems=Problem.search_items(condition[0],condition[1],condition[2],params["question_num#{params[:block_id]}"].to_i,doc.root.elements["problem_ids"].text)
    score_arr={}
    str=""
    @problems.each do |problem|
      str= doc.root.elements["problem_ids"].text+"," unless doc.root.elements["problem_ids"].text.nil?
      str += "#{problem.id},"
      problem.questions.each do |question|
        score_arr[question.id] = params["question_score#{params[:block_id]}"].to_i
      end
      xml=problem.create_problem_xml(doc,params[:block_id], {:score => score_arr})
      xml.root.elements["problem_ids"].text=str.chop
      Problem.write_xml(url, xml)
    end    
    redirect_to "/item_pools/#{@paper.id}/revise_item"
  end

  def index
    @problems = Problem.search_mothod(nil,nil,nil,nil,20, params[:page])
  end

  def index_search
    @problems = Problem.search_mothod(params[:mintime],params[:maxtime],params[:category],params[:type],20, params[:page])
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
      tag_ids = []
      tags.each do |tag|
        tag_ids << tag.id
      end                           #取得标签的ID数组  
      problem_array=[]
      @problems.each do |problem|
        if problem.total_num!=nil
          total_num=problem.total_num
          check_id = 0
          get_ids = []
          while (2**check_id<=problem.total_num)
            if (total_num%2 == 1)
              get_ids << check_id         #取得题目标签的ID数组（因tags表里存在数据结构，2**id=num）
            end
            check_id += 1
            total_num = total_num/2
          end
          if tag_ids-get_ids==[]         #判断tag_ids-get_ids,如果结果为空数组[],则说明符合标签要求
            problem_array << problem
          end
        end
      end
      @problems=problem_array.paginate(:page=>params[:page],:per_page=>20)
    end
    render 'index'
  end


   def new_page
     
   end
end
