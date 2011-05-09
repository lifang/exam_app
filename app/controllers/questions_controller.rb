class QuestionsController < ApplicationController
  def new
  end

  def create
    @problem=Problem.create(:title=>params[:problem][:title])
    @question_attrs=""
     index=0
    (1..params[:problem][:attr_sum].to_i).each do
      index +=1
      @question_attr+="#{params['attr#{index}_key']}.#{params['attr#{index}_value']  }"
    end
    @question=Question.create(:problem_id=>@problem.id,:answer=>params[:problem][:answer])
    @paper=Paper.find(params[:question][:paper_id])
    @paper.update_attributes(:updated_at=>Time.now)
    redirect_to  "/papers/#{params[:question][:paper_id]}/new_step_two"
   
  end

  def edit
    @problem=Problem.find(params[:question][:question_id])
    @question.update_attributes(:title=>params[:question][:title])   #修改 题面
    @question_point=QuestionPoint.find(params[:question][:point_id])
    @question_point.update_attributes(:answer=>params[:question][:answer])  #修改 答案
    index=0
    (1..params[:question][:index].to_i).each do
      index +=1
      @question_attr=QuestionAttr.find(params["attr#{index}_id"])
      @question_attr.update_attributes(:key=>params["attr#{index}_key"],:value=>params["attr#{index}_value"])  #修改 题枝
    end
    @paper=Paper.find(params[:question][:paper_id])
    @paper.update_attributes(:updated_at=>Time.now)    #修改 试卷的更新时间

    @question.block_question_relations.find_by_paper_block_id(params[:question][:block_id]).update_attributes(:score=>params[:question][:score],:assess_role=>params[:question][:assess_role]) #修改 成绩和评分规则
    redirect_to  "/papers/#{params[:question][:paper_id]}/new_step_two"

   
    
  end

  def  destroy
    @question=Question.find(params[:id])
    @question.destroy
    redirect_to request.referrer
  end
end
