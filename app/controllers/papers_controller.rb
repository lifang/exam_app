class PapersController < ApplicationController
  before_filter :access?

  def index
    @papers=Paper.find_by_sql("select * from papers p where p.creater_id=#{cookies[:user_id]} order by created_at desc").paginate(:per_page =>8, :page => params[:page],:order => "created_at desc",:conditions => ["title like ? " , "%#{params[:search]}%"])
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
    @paper=Paper.find(params[:id])
  end

  def create_step_one
    @paper=Paper.create(:creater_id=>cookies[:user_id],:title=>params[:paper][:title],:description=>params[:paper][:description])
    #@block=PaperBlock.create(:paper_id=>@paper.id,:title=>params[:paper][:block_title],:description=>params[:paper][:block_description])
    unless File.directory?("#{Rails.root}/public/papers")
      Dir.mkdir("#{Rails.root}/public/papers")
    end
    content ="<paper>"
    content+="<base_info>"
    content+="<id>#{@paper.id}</id>"
    content+="<title>#{@paper.id}</title>"
    content+="<creater>#{cookies[:user_name]}</creater>"
    content+="<created_at>#{@paper.created_at.strftime("%Y_%m_%d_%H_%M")}</created_at>"
    content+="<updated_at>#{@paper.updated_at.strftime("%Y_%m_%d_%H_%M")}</updated_at>"
    #str = Iconv.conv("UTF-8", "ASCII-8BIT", "#{params[:paper][:description]}")
    #content+="<description>#{str}</description>"
    content+="<description>#{params[:paper][:description].force_encoding('ASCII-8BIT')}</description>"
    content+="</base_info>"
    content+="<base_block>"
    content+="<title>#{params[:paper][:block_title].force_encoding('ASCII-8BIT')}</title>"
    content+="<description>#{params[:paper][:block_description].force_encoding('ASCII-8BIT')}</description>"
    content+="</base_block>"
    content+="</paper>"
    f=File.new("#{papers_path}/#{@paper.id}.txt","a+")
    f.write("#{content.force_encoding('UTF-8')}")
    f.close
    redirect_to "/papers/new_step_one"
  end

  def create_step_two
    PaperBlock.create(:paper_id=>params[:module][:paper_id],:title=>params[:module][:title],:description=>params[:module][:description])
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
  def delete_all
    Paper.find_by_sql("select * from papers where papers.id in (#{params[:deleteall][:delete_all]})").each  do |paper|
      paper.destroy
    end
    redirect_to "/users/new"
  end
  def new_exam_one
#        @aa=Paper.find_by_sql("select * from papers where papers.id in (#{params[:deleteall][:delete_all]})")
#       if params[:deleteall][:delete_all].empty?
#       flash[:noaccess]="请选择考卷"
#       redirect_to "/papers"
#     else
#       redrict_to "/papers/#{params[:deleteall][:delete_all]}/new_exam_one"
#     end
 
  end
  def create_exam_one
    @timeout=params[:timeout]
    @opened=params[:opened]
    @time=params[:time]
    redirect_to "/papers/new_exam_two"
#    @paperid=params[:deleteall][:delete_all]
#
#    @examination=Examination.create(:paper_id=>@paperid[rand(@paperid.length)],:title=>params[:title],:creater_id=>cookies[:user_id],:description=>params[:description],:is_paper_open=>params[:opened],
#      :start_at_time=>params[:d],:start_end_time=>params[:d]+params[:timeout].second.ago,:exam_time=>params[:timeout],:is_score_open=>params[:open_result])
#    @tex=get_text(params[:grade])
#    i=0
#    (0..@tex.length/2).each do
#      ScoreLevel.create(:examination_id=>@examination.id,:key=>@tex[i],:value=>@text[i+1])
#      i +=2
#    end
  end
  def new_exam_two
    
  end
  def create_exam_three

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

