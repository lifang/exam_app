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
     @block=PaperBlock.create(:paper_id=>@paper.id,:title=>params[:paper][:block_title],:description=>params[:paper][:block_description])
    unless File.directory?("#{Rails.root}/public/papers")
      Dir.mkdir("#{Rails.root}/public/papers")
    end
    content ="<?xml version='1.0' encoding='UTF-8'?>"
    content+="<paper id='#{@paper.id}' total_num='0' total_score='0'>"
    content+="<base_info>"
    content+="<title>#{@paper.title}</title>"
    content+="<creater>#{cookies[:user_name]}</creater>"
    content+="<created_at>#{@paper.created_at.strftime("%Y年%m月%d日%H时%M分").force_encoding('ASCII-8BIT')}</created_at>"
    content+="<updated_at>#{@paper.updated_at.strftime("%Y年%m月%d日%H时%M分").force_encoding('ASCII-8BIT')}</updated_at>"
    content+="<description>#{params[:paper][:description].force_encoding('ASCII-8BIT')}</description>"
    content+="</base_info>"
    content+="<blocks>"
    content+="<block id='#{@block.id}' total_num='0' total_score='0'>"
    content+="<base_info>"
    content+="<title>#{params[:paper][:block_title].force_encoding('ASCII-8BIT')}</title>"
    content+="<description>#{params[:paper][:block_description].force_encoding('ASCII-8BIT')}</description>"
    content+="</base_info>"
    content+="<problems>"
    content+="</problems>"
    content+="</block>"
    content+="</blocks>"
    content+="</paper>"
    f=File.new("#{papers_path}/#{@paper.id}.xml","a+")
    f.write("#{content.force_encoding('UTF-8')}")
    f.close
    redirect_to "/papers/#{@paper.id}/new_step_two"
  end

  def create_step_two
    PaperBlock.create(:paper_id=>params[:module][:paper_id],:title=>params[:module][:title],:description=>params[:module][:description])
    doc=Document.new(File.open "#{papers_path}/#{params[:problem][:paper_id].to_i}.xml")

    #数据丢失。。。。。 555555555555555555555
    
    file = File.new("#{papers_path}/#{params[:problem][:paper_id].to_i}.xml", "w+")
    file.write(doc)
    file.close
    redirect_to "/papers/#{params[:module][:paper_id]}/new_step_two"
  end
  
  def search
    @sql="select * from papers where creater_id=#{cookies[:user_id]}"
    if !params[:mintime].nil? and params[:mintime] != ""
      @sql += " and created_at > '#{params[:mintime]}'"
    end
    if !params[:maxtime].nil? and params[:maxtime] != ""
      @sql += " and created_at < '#{params[:maxtime]} '"
    end
    if !params[:search].nil? and params[:search] != ""
      @sql += " and title like '%#{params[:search]}%'"
    end
    if @sql !="select * from papers where creater_id=#{cookies[:user_id]}"
      @papers=Paper.find_by_sql(@sql).paginate(:per_page =>10, :page => params[:page],:order => "created_at desc")
    else
      @papers=Paper.find_by_sql(@sql).paginate(:per_page =>10, :page => params[:page],:order => "created_at desc")
      flash[:nosearch]="请输入条件"
    end
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

