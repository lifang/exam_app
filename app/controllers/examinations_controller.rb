class ExaminationsController < ApplicationController
  def new
    @examination=Examination.new()
  end

  #=====================
  #create by qianjun -- 2011-05-09
  #=====================
  def create
# @paperid=params[:deleteall][:delete_all]
@paperid=[1,2,3]
 @opened=params[:examplan][:radiovalue]
 @selectvalue=params[:examplan][:selectvalue]
 @result=params[:examplan][:see_result]
 @time=params[:time]
 @examination=Examination.create(:title=>params[:title],:creater_id=>cookies[:user_id],:description=>params[:description],:is_paper_open=>@opened[0],
  :start_at_time=>@time ,:start_end_time=>@time,:exam_time=>params[:timeout],:is_score_open=>@result)
 @grade_class=get_text(params[:grade])
  i=0
  (0..@grade_class.length/2-1).each do
    ScoreLevel.create(:examination_id=>@examination.id,:key=>@grade_class[i],:value=>@grade_class[i+1])
     i +=2
      end
  redirect_to "/papers"
 end
 
  def edit
 

   
    
  end

  def  destroy
  
  end
end
