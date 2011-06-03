class PapersController < ApplicationController

  require 'rexml/document'
  include REXML
  #include PapersHelper
  before_filter :access?

  def index
    @papers = Paper.search_mothod(cookies[:user_id].to_i, nil, nil, nil, nil, 10, params[:page])
  end

  def hand_in
    puts params["radio"]["163"]
    redirect_to request.referer
  end

  def destroy
    paper = Paper.find(params[:id])
    if paper.is_used
      flash[:warn] = "试卷已经被使用！"
    else
      flash[:notice] = "删除成功！"
      paper.destroy
    end
    redirect_to "/papers"
  end

  def change_info
    @paper=Paper.find(params[:id].to_i)
    @paper.update_attributes(:title=>params[:info][:title],
      :description=>params[:info][:description], :category_id => params[:category])
    if @paper.paper_url.nil?
      @paper.create_paper_url(@paper.xml_content({"category_name" => params["category_name_#{params[:category].to_i}"]}))
    else
      @paper.update_base_info(@paper.paper_url, {"category_name" => params["category_name_#{params[:category].to_i}"]})
    end
    redirect_to "/papers/#{@paper.id}/new_step_two"
  end

  def answer_paper
    file = File.open("#{Constant::PAPER_PATH}/#{params[:id]}.xml")
    @xml=Document.new(file).root
  end

  def show
    file = File.open("#{Constant::PAPER_PATH}/#{params[:id]}.xml")
    @xml=Document.new(file).root
  end

  def new_step_one
  end

  def create
    Paper.create(:paper_category_id=>"1",:title=>params[:paper][:paper_title],
      :description=>params[:paper][:paper_describe],:creater_id=>"#{User.find_by_name(cookies[:user_name]).id}",
      :total_score=>params[:paper][:paper_total_score],:total_question_num=>params[:paper][:paper_total_question_num])
  end

  def new_step_two
    file = File.open("#{Constant::PAPER_PATH}/#{params[:id]}.xml")
    @xml=Document.new(file).root
  end

  def create_step_one
    @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:paper][:title],
      :description=>params[:paper][:description], :category_id => params[:category])
    category = Category.find(params[:category].to_i)
    @paper.create_paper_url(@paper.xml_content({"category_name" => category.name}), "papers", "xml") unless category.nil?

#    @block=PaperBlock.create(:paper_id=>@paper.id,:title=>params[:paper][:block_title],
#      :description=>params[:paper][:block_description])
#    @block.create_block_xml(@paper.paper_url)                                        #XML操作
    
    redirect_to "/papers/#{@paper.id}/new_step_two"
  end

  def create_step_two
    @block = PaperBlock.create(:paper_id=>params[:module][:paper_id],:title=>params[:module][:title],:description=>params[:module][:description])
    @block.create_block_xml(@block.paper.paper_url)                                            #XML操作
    redirect_to request.referrer
  end

  
  def problem_destroy
    url= File.open "#{Constant::PAPER_PATH}/#{params[:delete][:paper_id]}.xml"
    doc = Problem.remove_problem_xml(Problem.open_xml(url), params[:delete][:xpath])
    Problem.write_xml(url, doc)
    redirect_to request.referrer
  end
  
  def edit_block
    @block=PaperBlock.find(params[:block][:block_id])
    @block.update_attributes(:title=>params[:block][:title],:description=>params[:block][:description])
    xpath=params[:block][:block_xpath]
    @block.update_block_xml(xpath)
    redirect_to request.referrer
  end
  
  def search
    session[:mintime] = nil
    session[:maxtime] = nil
    session[:title] = nil
    session[:category] = nil
    session[:mintime] = params[:mintime] if !params[:mintime].nil? and params[:mintime] != ""
    session[:maxtime] = params[:maxtime] if !params[:maxtime].nil? and params[:maxtime] != ""
    session[:title] = params[:title] if !params[:title].nil? and params[:title] != ""
    session[:category] = params[:category] if !params[:category].nil? and params[:category] != ""
    redirect_to search_list_papers_path
    
  end

  def search_list
    @papers = Paper.search_mothod(cookies[:user_id].to_i, session[:mintime], session[:maxtime],
      session[:title], session[:category], 10, params[:page])
    render 'index'
  end
  
  #创建试卷的js文件
  def create_all_paper
    @paper = Paper.find(params[:id].to_i)
    @paper.create_paper_url(@paper.create_paper_js, "paperjs", "js")
    redirect_to papers_url
  end

  
  def user_exist?
    if User.find(cookies[:user_id]) != current_user
      redirect_to root_path
    end
  end




end

