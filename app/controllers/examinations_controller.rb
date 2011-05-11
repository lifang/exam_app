class ExaminationsController < ApplicationController
  before_filter :access?
  
  def index
    @examinations = Examination.paginate_by_sql(
          ["select e.id e_id, e.title e_title, p.id p_id, p.title p_title, e.start_at_time,
            e.exam_time, e.created_at, e.is_score_open, e.is_published
            from examinations e inner join examination_paper_relations epr on epr.examination_id = e.id
            inner join papers p on epr.paper_id = p.id where e.creater_id = ? and epr.default = ? order by e.created_at desc",
        cookies[:user_id], ExaminationPaperRelation::DEFAULT[:YES]], :per_page => 1, :page => params[:page])
    
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
      flash[:error]="请选择试题"
      redirect_to "/papers"
    else
      @paperids=Paper.find(params[:exam][:getvalue].split(",")[0])
      render "/examinations/new_exam_one"
    end
  end
  
  def create_step_one
    @papers=Paper.find(params[:post_value].split(","))
    @selectvalue=params[:examplan][:selectvalue]
    @result=params[:examplan][:see_result]
    if params[:timelimit].to_i==1
      @time=params[:time].to_datetime + @selectvalue.to_i.minutes + @result.to_i.hours
      @overtime=@time + params[:accesstime].to_i.minutes
    else
      @time=""
      @overtime=""
    end
    hash1={:title=>params[:title],:creater_id=>cookies[:user_id],:description=>params[:description],:is_paper_open=>params[:opened],
      :start_at_time=>@time ,:start_end_time=>@overtime,:exam_time=>params[:timeout],:is_score_open=>params[:open_result]}
    @examination=Examination.create_examination(hash1)
    cookies[:examination_id]= @examination.id
    @grade_class=get_text(params[:grade])
    i=0
    (0..@grade_class.length/2-1).each do
      ScoreLevel.create(:examination_id=>@examination.id,:key=>@grade_class[i],:value=>@grade_class[i+1])
      i +=2
    end
    @examination.choose_paper(@papers)
    if params[:buttonvalue]=="创建"
      redirect_to "/examinations/exam_list"
    else
      redirect_to "/exam_users/new_exam_two"
    end
  end
 
  def edit

  end
  def new_exam_one
    
  end

  def  destroy
  
  end
end
