class ExaminationsController < ApplicationController

  def new
    @examination=Examination.new()
  end

  #=====================
  #create by qianjun -- 2011-05-09
  #=====================
  def create
    @paperid=params[:exam][:getvalue]
    render "/examinations/new_exam_one"
  end

  def create_step_one
#    @paperids=Paper.find(params[:postvalue])
    @selectvalue=params[:examplan][:selectvalue]
    @result=params[:examplan][:see_result]
    @timeout=params[:timeout]
    @time=params[:time].to_datetime + @selectvalue.to_i.minutes + @result.to_i.hours
    hash1={:title=>params[:title],:creater_id=>cookies[:user_id],:exam_password1=>"123456",:exam_password2=>"qianjun",:description=>params[:description],:is_paper_open=>params[:opened],
      :start_at_time=>@time ,:start_end_time=>@time + params[:timeout].to_i.minutes,:exam_time=>@timeout,:is_score_open=>params[:open_result]}
    @examination=Examination.create_examination(hash1)
    @grade_class=get_text(params[:grade])
    i=0
    (0..@grade_class.length/2-1).each do
      ScoreLevel.create(:examination_id=>@examination.id,:key=>@grade_class[i],:value=>@grade_class[i+1])
      i +=2
    end
    if params[:buttonvalue]=="创建"
      redirect_to "/examinations/exam_list"
    else
      redirect_to "/examinations/new_exam_two"
    end
  end
 
  def edit

  end
  def new_exam_one
    
  end

  def  destroy
  
  end
end
