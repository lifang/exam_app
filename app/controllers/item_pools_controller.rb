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
      puts "answer_question_attr[0]= #{answer_question_attr[0]}"
      puts "answer_question_attr[1]= #{answer_question_attr[1]}"
    end
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
        @problems=problem_array.paginate(:page=>params[:page],:per_page=>20)
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
  
end
