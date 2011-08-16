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
    @problems = Problem.search_mothod(nil,nil,nil,nil,nil,15, params[:page])
  end

  def search_condition
    session[:mintime] = nil
    session[:maxtime] = nil
    session[:category] = nil
    session[:type] = nil
    session[:tags] = nil
    session[:mintime] = params[:mintime]
    session[:maxtime] = params[:maxtime]
    session[:category] = params[:category]
    session[:type] = params[:type]
    session[:tags] = params[:tags]
    redirect_to index_search_item_pools_path
  end

  def index_search
    @problems = Problem.search_mothod(session[:mintime],session[:maxtime],session[:category],session[:type], session[:tags], 15, params[:page])
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

  def ajax_item_pools_edit_problem
    @problem=Problem.find(params[:id])
    render :partial=>"/item_pools/edit_problem",:object=>@problem
  end

  def ajax_item_pools_mavin_problem
    render :partial=>"/item_pools/mavin_question"
  end

    def item_pools_mavin_problem
    content = params[:problem][:title].gsub("<br />", "")
    #切割字符串,简答题以“{{}}”标志，其他题目都以“[[]]”标志,“||”后面为标签，“||”前为答案，
    #“|”用来区分选择题正误，前面为正确答案，后面为错误答案，“；”用来标识多个选项
    unless content.nil? or content == ""
      problem_correct_type = 0
      question_tmp = {} #用来记录初步分离的提点
      questions = [] #用来记录所有的提点
      problem_title = content.gsub(/\[\[(.|\n)+?\]\]/, "______").gsub(/\{\{(.|\n)+?\}\}/, "______")
      .gsub(/\[\{(.|\n)+?\}\]/, "").gsub(/\[\((.|\n)+?\)\]/, "")
      #非简答题以外的题
      if content.include? "[["
        question_tmp = Question.generate_question_hash(question_tmp, "]]", "[[", content)
        character_question = Question.generate_question_hash(question_tmp, "}}", "{{", content)
        question_tmp = question_tmp.merge(character_question)
        questions = Question.generate_question_for_database(question_tmp)
        if question_tmp.length == 1     #非综合题以外的题
          problem_correct_type = questions[0][:correct_type]
        else
          problem_correct_type = Problem::QUESTION_TYPE[:COLLIGATION]
        end
      elsif content.include? "{{"
        question_tmp = Question.generate_question_hash(question_tmp, "}}", "{{", content)
        questions = Question.generate_question_for_database(question_tmp)
        problem_correct_type = Problem::QUESTION_TYPE[:CHARACTER]
      end
      #保存题目和提点，并返回所有提点的分值
      scores = Question.generate_score_or_analysis(content, ")]", "[(")
      analysis = Question.generate_score_or_analysis(content, "}]", "[{")
      score_arr = {}
      @problem = Problem.create(:category_id=>params[:category].to_i,:title => problem_title, :types => problem_correct_type, :complete_title => content,:status=>Problem::PROBLEM_STATUS[:USED])
      (0..questions.length-1).each do |i|
        questions[i][:analysis] = analysis[i].nil? ? "" : analysis[i]
        @question = Question.create_question(@problem,
          {:answer => questions[i][:answer], :analysis => questions[i][:analysis],
            :correct_type => questions[i][:correct_type].to_i}, questions[i][:question_attr])
        score_arr[@question.id] = scores[i].nil? ? 0 : scores[i]
        #创建标签
        if !questions[i][:tag].nil? and questions[i][:tag] != ""
          tag_name = questions[i][:tag].split(" ")
          @question.question_tags(Tag.create_tag(tag_name))
        end
      end
      @problem.update_problem_tags
    end
    redirect_to  "/item_pools"
  end

  def update_problem
    @problem = Problem.find(params[:problem][:problem_id].to_i)
    #更新题面
    @problem.update_attributes(:title=>params[:problem][:title].strip, :updated_at=>Time.now)
    #更新提点
    score_arr = {}
    if @problem.types == Problem::QUESTION_TYPE[:COLLIGATION]
      score_arr = Question.update_colligation_questions(@problem,
        Question.colligation_questions(params["edit_coll_question_" + params[:problem][:problem_id]]), "update")
    else
      answer_question_attr = answer_text(@problem.types,
        params[:problem][:attr_sum].to_i, params[:problem][:answer],params[:problem][:question_id])
      @question = Question.update_question(params[:problem][:question_id],
        {:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis].strip,
          :correct_type => params[:problem][:correct_type].to_i}, answer_question_attr[1])
      if !params[:tag].nil? and params[:tag].strip != ""
        tag_name = params[:tag].strip.split(" ")
        @question.question_tags(Tag.create_tag(tag_name))
      end
      score_arr[@question.id] = params[:problem][:score].to_i
    end
    @problem.update_problem_tags
    redirect_to "/item_pools"
  end

    def ajax_item_pools_edit_question
    @question = Question.find(params[:question_id])
    render :partial => "/item_pools/edit_other_question", :object => @question
  end

end
