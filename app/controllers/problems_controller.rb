class ProblemsController < ApplicationController
  before_filter :access?

  require 'rexml/document'
  include REXML
  
  def create
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    #创建题目
    @problem = Problem.create_problem(@paper, {:title=>params[:problem][:title], :types => params[:real_type].to_i})
    #创建题点
    answer_question_attr = answer_text(params[:real_type].to_i, 
      params[:problem][:attr_sum].to_i, params[:problem][:answer])
    @question = Question.create_question(@problem,
      {:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis],
        :correct_type => params[:real_type].to_i}, answer_question_attr[1])
    #创建标签
    if !params[:tag].nil? and params[:tag] != ""
      tag_name = params[:tag].split(" ")
      @question.question_tags(Tag.create_tag(tag_name))
    end
    @problem.update_problem_tags
    #更新试卷xml
    url = File.open "#{papers_path}/#{params[:problem][:paper_id].to_i}.xml"
    @problem.create_problem_xml(url, params[:problem][:block_id], {:score => params[:problem][:score].to_i})

    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"
  end

  #组装答案和选项
  def answer_text(problem_type, attr_num, answer)
    answer_question_attr = []
    attrs_array = []
    if problem_type == Problem::QUESTION_TYPE[:SINGLE_CHOSE]
      answer_index = params[:attr_key].to_i
      answer_question_attr << params["attr#{answer_index}_value"]
      (1..attr_num).each do |i|
        attrs_array << params["attr#{i}_value"]
      end
      answer_question_attr << attrs_array
    elsif problem_type == Problem::QUESTION_TYPE[:MORE_CHOSE]
      answer_index = []
      (1..attr_num).each do |i|
        if !params["attr#{i}_key"].nil? and params["attr#{i}_key"] != ""
          attr_key = params["attr#{i}_key"].to_i
          answer_index << params["attr#{attr_key}_value"].gsub(";", ",")
        end
        attrs_array << params["attr#{i}_value"].gsub(";", ",")
      end
      answer_question_attr << answer_index.join(";")
      answer_question_attr << attrs_array
    elsif problem_type == Problem::QUESTION_TYPE[:JUDGE]
      answer_question_attr << params[:attr_key].to_i
      answer_question_attr << []
    elsif problem_type == Problem::QUESTION_TYPE[:SINGLE_CALK] or problem_type == Problem::QUESTION_TYPE[:CHARACTER]
      answer_question_attr << answer
      answer_question_attr << []
    end
    return answer_question_attr
  end

  def update_problem
    @question=Question.find(params[:problem][:question_id].to_i)               
    @attrs_array=Array.new
    (0..params[:problem][:attr_sum].to_i - 1).each do |i|
      value=params["attr#{i}_value"]
      @attrs_array << "#{value}"
    end
    @questionattrs=@attrs_array.join(";-;")
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
    question.elements["answer"].text = @question.answer
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
end
