class PapersController < ApplicationController

  require 'rexml/document'
  include REXML
  
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
    @paper.update_attributes(:total_question_num=>params[:info][:total_question_num],:description=>params[:info][:description])
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
    #file = File.open("#{papers_path}/text.xml")
    @xml=Document.new(file).root
  end

  def create_step_one
     @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:paper][:title],:description=>params[:paper][:description])
     @paper.create_paper_url(@paper.xml_content(cookies[:user_name]))                    #创建XML文件，更新字段paper_url
     @block=PaperBlock.create(:paper_id=>@paper.id,:title=>params[:paper][:block_title],:description=>params[:paper][:block_description])
     @block.update_block_xml(@paper.paper_url)
    redirect_to "/papers/#{@paper.id}/new_step_two"
  end

  def create_step_two
    @paper_block = PaperBlock.create(:paper_id=>params[:module][:paper_id],:title=>params[:module][:title],:description=>params[:module][:description])
    @paper_block.update_block_xml(@paper_block.paper_id)
    redirect_to "/papers/#{params[:module][:paper_id]}/new_step_two"
  end
REXML
  def problem_destroy
    doc=Document.new(File.open "#{papers_path}/#{params[:delete][:paper_id]}.xml")
    block=doc.elements[params[:delete][:xpath]].parent.parent
    doc.root.attributes["total_num"] = doc.root.attributes["total_num"].to_i - 1                   #更新试卷总题数 +1
    block.attributes["total_num"] = block.attributes["total_num"].to_i - 1                         #更新试卷总题数 -1
    doc.root.attributes["total_score"] = doc.root.attributes["total_score"].to_i - doc.elements[params[:delete][:xpath]].attributes["score"].to_i
                                                                                                   #更新试卷总分
    block.attributes["total_score"] = block.attributes["total_score"].to_i - doc.elements[params[:delete][:xpath]].attributes["score"].to_i
                                                                                                   #更新模块总分
    doc.delete_element(params[:delete][:xpath])
    file=File.new("#{papers_path}/#{params[:delete][:paper_id]}.xml", "w+")
    file.write(doc)
    file.close
    redirect_to "/papers/#{params[:delete][:paper_id]}/new_step_two"
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

