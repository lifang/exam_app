class PapersController < ApplicationController

  require 'rexml/document'
  include REXML
  include PapersHelper
  before_filter :access?

  def index
    @papers = Paper.paginate_by_sql(["select * from papers p where p.creater_id=#{cookies[:user_id]} order by p.created_at desc"],
      :per_page => 1, :page => params[:page])
  end

  def new
    
  end

  def destroy
    Paper.find(params[:id]).destroy
    redirect_to "/papers"
  end

  def change_info
    @paper=Paper.find(params[:id])
    @paper.update_attributes(:title=>params[:info][:title],:description=>params[:info][:description])
    @paper.update_base_info(@paper.paper_url)
    redirect_to "/papers/#{@paper.id}/new_step_two"
  end


  def create
    Paper.create(:paper_category_id=>"1",:title=>params[:paper][:paper_title],:description=>params[:paper][:paper_describe],:creater_id=>"#{User.find_by_name(cookies[:user_name]).id}",:total_score=>params[:paper][:paper_total_score],:total_question_num=>params[:paper][:paper_total_question_num])
  end


  def show
    @paper=Paper.find(params[:id])
    @blocks= @paper.paper_blocks
  end

  def new_step_one
  end

  def create
    Paper.create(:paper_category_id=>"1",:title=>params[:paper][:paper_title],:description=>params[:paper][:paper_describe],:creater_id=>"#{User.find_by_name(cookies[:user_name]).id}",:total_score=>params[:paper][:paper_total_score],:total_question_num=>params[:paper][:paper_total_question_num])
  end

  def new_step_two
    file = File.open("#{papers_path}/#{params[:id]}.xml")
    @xml=Document.new(file).root
  end

  def create_step_one
     @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:paper][:title],:description=>params[:paper][:description])
     @paper.create_paper_url(@paper.xml_content(cookies[:user_name]))                              #XML操作
     @block=PaperBlock.create(:paper_id=>@paper.id,:title=>params[:paper][:block_title],:description=>params[:paper][:block_description])
     @block.create_block_xml(@paper.paper_url)                                        #XML操作
    redirect_to "/papers/#{@paper.id}/new_step_two"
  end

  def create_step_two
    @block = PaperBlock.create(:paper_id=>params[:module][:paper_id],:title=>params[:module][:title],:description=>params[:module][:description])
    @block.create_block_xml(@block.paper.paper_url)                                            #XML操作
    redirect_to request.referrer
  end

  
  def problem_destroy
    url="#{papers_path}/#{params[:delete][:paper_id]}.xml"
    problem_xpath=params[:delete][:xpath]
    xml_delete_problem(url,problem_xpath)                   #删除题目
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
    if !params[:mintime].nil? and params[:mintime] != ""
      session[:mintime] = params[:mintime]
    end
    if !params[:maxtime].nil? and params[:maxtime] != ""
      session[:maxtime] = params[:maxtime]
    end
    if !params[:title].nil? and params[:title] != ""
      session[:title] = params[:title]
    end
    if !params[:category].nil? and params[:category] != ""
      session[:category] = params[:category]
    end
    redirect_to search_list_papers_path
    
  end

  def search_list
     @sql = "select * from papers where creater_id=#{cookies[:user_id]}"
     if !session[:mintime].nil?
      @sql += " and created_at > '#{session[:mintime]}'"
    end
    if !session[:maxtime].nil?
      @sql += " and created_at < '#{session[:maxtime]}'"
    end
    if !session[:title].nil?
      @sql += " and title like '%#{session[:title]}%'"
    end
    if !session[:category].nil?
      @sql += " and category_id = '%#{session[:category]}%'"
    end
      @sql += " order by created_at desc"
      @papers = Paper.paginate_by_sql(@sql, :per_page =>1, :page => params[:page])
      render 'index'
  end
  
  def edit
  end

  def new
  end
  
  def user_exist?
    if User.find(cookies[:user_id]) != current_user
      redirect_to root_path
    end
  end




end

