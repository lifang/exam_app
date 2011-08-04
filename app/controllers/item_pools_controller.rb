# encoding: utf-8
class ItemPoolsController < ApplicationController
  require 'rexml/document'
  include REXML
  before_filter :access?

  def create
    @type = params[:problem][:real_type].to_i
    @problem = Problem.create(:category_id=>params[:category].to_i,:title=>params[:problem][:title].strip, :types =>@type )
    if params[:problem][:real_type].to_i==Problem::QUESTION_TYPE[:COLLIGATION]
      score_arr = Question.update_colligation_questions(@problem,
        Question.colligation_questions(params["single_question"]), "create")
    else
      answer_question_attr=item_pool_answer_text(params[:problem][:real_type].to_i, params[:problem][:attr_sum].to_i, params[:problem][:answer])
      @question = Question.create_question(@problem,{:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis].strip,
          :correct_type => params[:problem][:correct_type].to_i}, answer_question_attr[1])
      if params[:tags]!=nil||params[:tags]!=''
        tag_name = params[:tag].strip.split(" ")
        @question.question_tags(Tag.create_tag(tag_name))
      end
    end
    @problem.update_problem_tags
    redirect_to "/item_pools"
  end

  def item_pool_answer_text(problem_type, attr_num, answer, question_id="")
    puts problem_type
    puts attr_num
    answer_question_attr = []
    attrs_array = []
    if problem_type == Problem::QUESTION_TYPE[:SINGLE_CHOSE]
      answer_index = params["attr_key#{question_id}"].to_i
      answer_question_attr << params["attr#{answer_index}_value#{question_id}"]
      (1..attr_num).each do |i|
        if !params["attr#{i}_value#{question_id}"].nil? && params["attr#{i}_value#{question_id}"] != ""
          attrs_array << params["attr#{i}_value#{question_id}"]
        end
      end
      answer_question_attr << attrs_array
      
    elsif problem_type == Problem::QUESTION_TYPE[:MORE_CHOSE]
      answer_index = []
      (1..attr_num).each do |i|
        if !params["attr#{i}_key#{question_id}"].nil? and params["attr#{i}_key#{question_id}"] != ""
          attr_key = params["attr#{i}_key#{question_id}"].to_i
          answer_index << params["attr#{attr_key}_value#{question_id}"]
        end
        if !params["attr#{i}_value#{question_id}"].nil? && params["attr#{i}_value#{question_id}"] != ""
          attrs_array << params["attr#{i}_value#{question_id}"]
        end
      end
      answer_question_attr << answer_index.join(";|;")
      answer_question_attr << attrs_array
    elsif problem_type == Problem::QUESTION_TYPE[:JUDGE]
      answer_question_attr << params["attr_key#{question_id}"].to_i
      answer_question_attr << []
    elsif problem_type == Problem::QUESTION_TYPE[:SINGLE_CALK] or problem_type == Problem::QUESTION_TYPE[:CHARACTER]
      answer_question_attr << answer
      answer_question_attr << []
    end
    return answer_question_attr
  end

  def create_paper
    @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:title].strip,
      :description=>params[:description].strip, :category_id => params[:category])
    category = Category.find(params[:category].to_i)
    @paper.create_paper_url(@paper.xml_content({"category_name" => category.name}), "papers", "xml") unless category.nil?
    redirect_to "/item_pools/#{@paper.id}/revise_item"
  end
  j
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

  def search_condition
    session[:mintime] = nil
    session[:maxtime] = nil
    session[:category] = nil
    session[:type] = nil
    session[:tags] = nil
    session[:mintime] = params[:mintime] if !params[:mintime].nil? and params[:mintime] != ""
    session[:maxtime] = params[:maxtime] if !params[:maxtime].nil? and params[:maxtime] != ""
    session[:category] = params[:category] if !params[:category].nil? and params[:category]!=""
    session[:type] = params[:type] if !params[:type].nil? and params[:type] != ""
    session[:tags] = params[:tags] if !params[:tags].nil? and params[:tags] != ""
    redirect_to index_search_item_pools_path
  end

  def index_search
    @problems = Problem.search_mothod(session[:mintime],session[:maxtime],session[:category],session[:type],20, params[:page])
    unless session[:tags].nil?||session[:tags]==""
      tags = session[:tags].split(" ")
      in_condition = tags.to_s.gsub("[","").gsub("]","")
      tags = Tag.where("name in (#{in_condition})")
      
      false_sum = 0         
      problem_array=[]
      if tags.count!=0
      @problems.each do |problem|
        if problem.total_num!=nil
          tags.each do |tag|
            if problem.total_num%tag.num!=0
              false_sum += 1
            end          
          end
          if false_sum == 0
            problem_array << problem
          end
        end
        false_sum=0
      end
        @problems=problem_array.paginate(:page=>params[:page],:per_page=>20)
      else
        @problems=[].paginate(:page=>params[:page],:per_page=>20)
      end

    end
      
    render 'index'
  end

  def choose_type     #适用于普通题
    @problem_type=params[:type].to_i
    @question_type=@problem_type
    if @problem_type==Problem::QUESTION_TYPE[:SINGLE_CHOSE]
      render :partial=>"/item_pools/single_choose"
    elsif @problem_type==Problem::QUESTION_TYPE[:MORE_CHOSE]
      render :partial=>"/item_pools/more_choose"
    elsif @problem_type==Problem::QUESTION_TYPE[:JUDGE]
      render :partial=>"/item_pools/judge"
    elsif @problem_type==Problem::QUESTION_TYPE[:SINGLE_CALK]
      render :partial=>"/item_pools/fill_blank"
    elsif @problem_type==Problem::QUESTION_TYPE[:COLLIGATION]
      render :partial=>"/item_pools/colligation"
    elsif @problem_type==Problem::QUESTION_TYPE[:CHARACTER]
      render :partial=>"/item_pools/fill_blank"
    end
  end

  def colligation_choose_type   #适用于综合题选小题
    @problem_type = Problem::QUESTION_TYPE[:COLLIGATION]
    @question_type = params[:question_type].to_i
    if @question_type==Problem::QUESTION_TYPE[:SINGLE_CHOSE]
      render :partial=>"/item_pools/single_choose"
    elsif @question_type==Problem::QUESTION_TYPE[:MORE_CHOSE]
      render :partial=>"/item_pools/more_choose"
    elsif @question_type==Problem::QUESTION_TYPE[:JUDGE]
      render :partial=>"/item_pools/judge"
    elsif @question_type==Problem::QUESTION_TYPE[:SINGLE_CALK]
      render :partial=>"/item_pools/fill_blank"
    elsif @question_type==Problem::QUESTION_TYPE[:CHARACTER]
      render :partial=>"/item_pools/fill_blank"
    end
  end

  def ajax_item_pools_problem_info
    @problem=Problem.find(params[:id])
    render :partial=>"/item_pools/item_pools_show",:object=>@problem
  end
  
end
