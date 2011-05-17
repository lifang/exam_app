class ExaminationsController < ApplicationController
  before_filter :access?
  
  def index
    @examinations = Examination.search_method(cookies[:user_id].to_i, nil, nil, nil, 10, params[:page])
  end

  def search
    session[:start_at] = nil
    session[:end_at] = nil
    session[:title] = nil    
    if !params[:start_at].nil? and params[:start_at] != ""
      session[:start_at] = params[:start_at]
    end
    if !params[:end_at].nil? and params[:end_at] != ""
      session[:end_at] = params[:end_at]
    end
    if !params[:title].nil? and params[:title] != ""
      session[:title] = params[:title]
    end
    redirect_to search_list_examinations_path

  end

  def search_list
    @examinations = Examination.search_method(cookies[:user_id].to_i, session[:start_at], session[:end_at],
      session[:title], 10, params[:page])
    render "index"
  end

  def new
    @examination=Examination.new()
  end

  #=====================
  #create by qianjun -- 2011-05-09
  #=====================
  def create
    @paperid=params[:exam][:getvalue]
    if @paperid==""
      flash[:error]="请选择试卷"
      redirect_to "/papers"
    else
      paper_ids = []
      params[:exam][:getvalue].split(",").each {|i| paper_ids << i.to_i}
      papers = Paper.find(paper_ids)
      @paperids = papers[0]
      @examination = Examination.create!(:title => @paperids.title, :creater_id => cookies[:user_id].to_i)
      @examination.update_paper("create", papers)
      render "/examinations/new_exam_one"
    end
  end
  
  def create_step_one
    puts "======================================================"
    puts params[:id]
    @examination = Examination.find(params[:id].to_i)
    @selectvalue = params[:examplan][:selectvalue]
    @result = params[:examplan][:see_result]
    hash1 = {:title=>params[:title], :description=>params[:description], :is_paper_open=>params[:opened],
      :exam_time=>params[:timeout], :is_score_open=>params[:open_result]}
    if params[:timelimit].to_i==1
      @time=params[:time].to_datetime + @selectvalue.to_i.minutes + @result.to_i.hours
      @overtime=@time + params[:accesstime].to_i.minutes
      hash1[:start_at_time] = @time
      hash1[:start_end_time] = @overtime
    end
    @examination.update_examination(hash1)
    cookies[:examination_id]= @examination.id
    @grade_class=get_text(params[:grade])
    i=0
    (0..@grade_class.length/2-1).each do
      ScoreLevel.create(:examination_id=>@examination.id,:key=>@grade_class[i],:value=>@grade_class[i+1])
      i +=2
    end
    #@examination.update_paper('create', @papers.to_a)
    if params[:buttonvalue]=="创建"
      redirect_to "/exam_users/#{@examination.id}/new_exam_two"
    else
      redirect_to "/examinations"
    end
  end
 
  def edit
    @examination = Examination.find(params[:id].to_i)
     @exam_users = ExamUser.select_exam_users(@examination)
  end
  
  def new_exam_one
    
  end

  def show
    @examination = Examination.find(params[:id].to_i)
    @exam_users = ExamUser.select_exam_users(@examination)
  end

  def  destroy
    Examination.delete(params[:id].to_i)
    flash[:notice] = "删除成功！"
    redirect_to examinations_path
  end

  def published
    examination = Examination.find(params[:id].to_i)
    examination.publish!
    flash[:notice] = "发布成功！"
    redirect_to examinations_path
  end

  def paper_delete
    ids = params[:id].split("_")
    examination = Examination.find(ids[0].to_i)
    paper = Paper.find(ids[1].to_i)
    examination.papers.delete(paper)
    render :inline => ""
  end

  def search_papers
    examination = Examination.find(params[:id].to_i)
    paper_ids = []
    options = {}
    unless examination.papers.blank?
    examination.papers.each {|paper| paper_ids << paper.id } 
    options = {"id" => " not in (#{paper_ids.join(',')})"}
    end
    @papers = Paper.search_mothod(cookies[:user_id].to_i, session[:mintime], session[:maxtime],
      session[:title], session[:category], 10, params[:page], options)
    render :partial => "/examinations/search_papers"
  end

  def choose_papers
    examination = Examination.find(params[:id].to_i)
    if !params[:exam_getvalue].nil? and params[:exam_getvalue] != ""
      paper_ids = []
      params[:exam_getvalue].split(",").each { |i| paper_ids << i.to_i }
      papers = Paper.find(paper_ids)
      examination.papers += papers
      render :partial => "/examinations/paper_already_in_exam", :object => examination
    end
  end
  
end
