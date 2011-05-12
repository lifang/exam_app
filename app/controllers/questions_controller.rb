class QuestionsController < ApplicationController

  require 'rexml/document'
  include REXML

  def new
  end

  def create  #新建题目
    @problem=Problem.create(:title=>params[:problem][:title])
    @attrs_array=Array.new
    index=0
    (1..params[:problem][:attr_sum].to_i).each do
      index +=1
      key=params["attr#{index}_key"]
      value=params["attr#{index}_value"]
      @attrs_array << "#{key}:#{value}"
    end
    @questionattrs=@attrs_array.join("; ")
    @question=Question.create(:problem_id=>@problem.id,:answer=>params[:problem][:answer],:question_attrs=>@questionattrs)
    @paper=Paper.find(params[:problem][:paper_id])
    @paper.update_attributes(:updated_at=>Time.now)

    
    doc=Document.new(File.open "#{papers_path}/#{params[:problem][:paper_id].to_i}.xml")
    block=doc.root.elements["blocks"].elements["block[@id='#{params[:problem][:block_id]}']"]
    problems=block.elements["problems"]
    problem=problems.add_element("problem")
    problem.add_attribute("id","#{@problem.id}")
    add_score=params[:problem][:score].to_i
    problem.add_attribute("score","#{add_score}")
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y年%m月%d日%H时%M分")      #试卷更新时间
    doc.root.attributes["total_score"] = doc.root.attributes["total_score"].to_i + add_score       #更新试卷总分
    doc.root.attributes["total_num"] = doc.root.attributes["total_num"].to_i + 1                   #更新试卷总题数 +1
    block.attributes["total_score"] = block.attributes["total_score"].to_i + add_score             #更新模块总分
    block.attributes["total_num"] = block.attributes["total_num"].to_i + 1                         #更新模块总题数 +1
    title=problem.add_element("title")
    title.add_text("#{@problem.title}")
    questions=problem.add_element("questions")
    question=questions.add_element("question")
    question.add_attribute("id","#{@question.id}")
    question.add_attribute("answer","#{params[:problem][:answer]}")
    questionattrs=question.add_element("questionattrs")
    questionattrs.add_text("#{@question.question_attrs}")
    file = File.new("#{papers_path}/#{params[:problem][:paper_id].to_i}.xml", "w+")
    file.write(doc)
    file.close
    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"
   
  end

  def edit
    @question=Question.find(params[:problem][:question_id].to_i)                #-----start-------------数据库操作
    @attrs_array=Array.new
    index=0
    (1..params[:problem][:attr_sum].to_i).each do
      index +=1
      key=params["attr#{index}_key"]
      value=params["attr#{index}_value"]
      @attrs_array << "#{key}:#{value}"
    end
    @questionattrs=@attrs_array.join(";")
    @question.update_attributes(:question_attrs=>@questionattrs,:answer=>params[:problem][:answer])   #修改题点
    @problem =@question.problem
    @problem.update_attributes(:title=>params[:problem][:title])  #修改题目
    @paper=Paper.find(params[:problem][:paper_id])
    @paper.update_attributes(:updated_at=>Time.now)    #修改 试卷的更新时间      #-----end-------------数据库操作

    doc=Document.new(File.open "#{papers_path}/#{params[:problem][:paper_id].to_i}.xml")                       #------start---XML操作
    doc.root.elements["base_info"].elements["updated_at"].text=Time.now.strftime("%Y年_%m月_%d日_%H时_%M分")      #试卷更新时间
    problem = doc.elements["#{params[:problem][:problem_xpath]}"]
    question = problem.elements["questions"].elements["question"]
    question.elements["questionattrs"].text = @questionattrs
    question.attributes["answer"] = @question.answer
    problem=question.parent.parent
    problem.elements["title"].text = @problem.title
    block = problem.parent.parent
    block.attributes["total_score"] = block.attributes["total_score"].to_i - problem.attributes["score"].to_i  #模块更新总分第一步----减去以前分数
    doc.root.attributes["total_score"] = doc.root.attributes["total_score"].to_i - problem.attributes["score"].to_i    #试卷更新总分第一步----减去以前前分数
    problem.attributes["score"] = params[:problem][:score]
    block.attributes["total_score"] = block.attributes["total_score"].to_i + problem.attributes["score"].to_i     #模块更新总分第二步----加上现在分数
    doc.root.attributes["total_score"] = doc.root.attributes["total_score"].to_i + problem.attributes["score"].to_i    #试卷更新总分第二步----加上现在分数
    file = File.new("#{papers_path}/#{params[:problem][:paper_id].to_i}.xml", "w+")                             #xml文件更新（重写文件）
    file.write(doc)
    file.close                                                                                                     #------end---_XML操作
    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"

   
    
  end

  def  destroy
    @question=Question.find(params[:id])
    @question.destroy
    redirect_to request.referrer
  end
  
end
