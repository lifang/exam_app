class ExaminationsController < ApplicationController
  before_filter :access?
  
  def index #考试安排列表
    @examinations = Examination.search_method(cookies[:user_id].to_i, nil, nil, nil, 10, params[:page])
  end

  def search
    session[:start_at] = nil
    session[:end_at] = nil
    session[:title] = nil    
    session[:start_at] = params[:start_at] if !params[:start_at].nil? and params[:start_at] != ""
    session[:end_at] = params[:end_at] if !params[:end_at].nil? and params[:end_at] != ""
    session[:title] = params[:title] if !params[:title].nil? and params[:title] != ""
    redirect_to search_list_examinations_path

  end

  def search_list #查询考试安排
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
  def create  #创建考试按钮，获取试卷id
    @paperid=params[:exam][:getvalue]
    if @paperid==""
      flash[:warn]="请选择试卷"
      redirect_to "/papers"
    else
      paper_ids = []
      params[:exam][:getvalue].split(",").each {|i| paper_ids << i.to_i}
      papers = Paper.find(paper_ids)
      @paperids = papers[0]
      @examination = Examination.create!(:title => @paperids.title, :creater_id => cookies[:user_id].to_i,
        :is_published => false)
      @examination.update_paper("create", papers.to_a)
      render "/examinations/new_exam_one"
    end
  end
  
  def create_step_one  #创建考试
    @examination = Examination.find(params[:id].to_i)
    hour = (params[:hour] != "-1") ? params[:hour].to_i : 0
    min = (params[:minute] != "-2") ? params[:minute].to_i : 0
    hash1 = {:title => params[:title].strip, :description => params[:description].strip,
      :is_paper_open => params[:opened], :exam_time => params[:timeout], :is_score_open => params[:open_result],
      :user_affirm => params[:user_affirm], :status => Examination::STATUS[:GOING]}
    hash1[:generate_exam_pwd] = params[:generate_exam_pwd] == "1" ? true : false
    if params[:timelimit] == "1"
      @time=params[:time].to_date + min.to_i.minutes + hour.to_i.hours
      @overtime=@time + params[:accesstime].to_i.minutes
      hash1[:start_at_time] = @time
      hash1[:start_end_time] = @overtime
      hash1[:status] = Examination::STATUS[:LOCK]
    end
    @examination.update_examination(hash1)
    if !params[:grade].nil? and params[:grade] != ""
      @grade_class=get_text(params[:grade])
      @examination.update_score_level(@grade_class)
    end
    redirect_to "/examinations/#{@examination.id}"
  end

  def edit_base_info
    @examination = Examination.find(params[:id].to_i)
    render :partial => "edit_exam_base_info"
  end

  def back_base_info
    @examination = Examination.find(params[:id].to_i)
    render :partial => "exam_base_info"
  end
  
  def export_user_unaffirm  #输出未确认的考生信息
    url = Constant::PUBLIC_PATH + Constant::UNAFFIRM_PATH
    unless File.directory?(url)               #判断dir目录是否存在，不存在则创建 下3行
      Dir.mkdir(url)
    end
    file_url = "/#{params[:id].to_i}_#{Time.now.strftime("%Y%m%d%H%M%S")}.xls"
    ExamUser.export_user_unaffirm(url + file_url, params[:id].to_i)
    render :inline => "<script>window.location.href='#{Constant::UNAFFIRM_PATH}#{file_url}';</script>"
  end

  def show  #examination的显示
    @examination = Examination.find(params[:id].to_i)
    @exam_users = ExamUser.paginate_exam_user(@examination.id, 10,params[:page])
    @exam_raters = Examination.paginate_by_sql("select * from exam_raters r where r.examination_id = #{@examination.id}",
      :per_page => 10, :page => params[:page])
    @exam_all={}
    @exam_raters.collect() { |exam_rater| @exam_all["#{exam_rater.id}"]=[RaterUserRelation.find_by_sql("select sum(rate_time) long_time, count(id) sum from rater_user_relations where exam_rater_id=#{exam_rater.id} group by exam_rater_id"),exam_rater] }
   puts @exam_all
    @score_levels=@examination.score_levels
    render :partial => "exam_user_for_now" if request.xml_http_request? and params[:kind] == 'exam_user'
    render :partial => "exam_rater" if request.xml_http_request? and params[:kind] == 'exam_rater'
  end

  def  destroy  #删除安排
    Examination.delete(params[:id].to_i)
    flash[:notice] = "删除成功！"
    redirect_to examinations_path
  end

  def published  #发布试卷
    examination = Examination.find(params[:id].to_i)
    examination.publish!
    flash[:notice] = "发布成功！"
    redirect_to examinations_path
  end

  def paper_delete  #重新选择试卷
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

  def update_base_info
    @examination = Examination.find(params[:id].to_i)
    hash1 = {:title => params[:title].strip, :description => params[:description].strip,
      :is_paper_open => params[:opened], :exam_time => params[:timeout], :is_score_open => params[:open_result],
      :user_affirm => params[:user_affirm], :status => Examination::STATUS[:GOING]}
    hash1[:generate_exam_pwd] = params[:generate_exam_pwd] == "1" ? true : false
    if params[:timelimit] == "1"
      hour = (params[:hour] != "-1") ? params[:hour].to_i : 0
      min = (params[:minute] != "-2") ? params[:minute].to_i : 0
      @time=params[:time].to_date + hour.hours + min.minutes
      @overtime=@time + params[:accesstime].to_i.minutes
      hash1[:start_at_time] = @time
      hash1[:start_end_time] = @overtime
      hash1[:status] = Examination::STATUS[:LOCK]
    else
      hash1[:start_at_time]=""
      hash1[:start_end_time] = @overtime
    end
    @examination.update_examination(hash1)
    if !params[:grade].nil? and params[:grade] != ""
      @grade_class=get_text(params[:grade])
      @examination.update_score_level(@grade_class)
    end
    render :partial => "exam_base_info" 
  end
  
  def exam_result
    @examination = Examination.find(params[:id].to_i)
    @exam_users = ExamUser.return_exam_result(@examination.id, 10, params[:page])
    @exam_user_hash = ExamUser.score_level_result(@examination, @exam_users)
  end

  def search_result
    session[:search_text] = nil
    session[:search_text] = params[:search_text] if !params[:search_text].nil? and params[:search_text] != ""
    redirect_to "/examinations/#{params[:id]}/single_result_list"
  end

  def single_result_list
    @examination = Examination.find(params[:id].to_i)
    sql = ExamUser.generate_sql(@examination.id)
    sql += " and (u.email like '%#{session[:search_text]}%' or u.name like '#{session[:search_text]}%') "
    @exam_users = ExamUser.paginate_by_sql(sql, :per_page =>1, :page => params[:page])
    @exam_user_hash = ExamUser.score_level_result(@examination, @exam_users)
    render "exam_result"
  end

  def close
    @examination = Examination.find(params[:id].to_i)
    @examination.status = Examination::STATUS[:CLOSED]
    @examination.save
    redirect_to request.referer
  end
  
end
