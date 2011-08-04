# encoding: utf-8
class ProblemsController < ApplicationController
  before_filter :access?
  
  def create
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    #创建题目
    @problem = Problem.create_problem(@paper, {:title=>params[:problem][:title].strip, :types => params[:real_type].to_i})
    #创建题点
    score_arr = {}
    if params[:real_type].to_i == Problem::QUESTION_TYPE[:COLLIGATION]
      score_arr = Question.update_colligation_questions(@problem,
        Question.colligation_questions(params["single_question_#{params[:problem][:block_id]}"]), "create")
    else
      answer_question_attr = answer_text(params[:problem][:correct_type].to_i,
        params[:problem][:attr_sum].to_i, params[:problem][:answer])
      @question = Question.create_question(@problem,
        {:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis].strip,
          :correct_type => params[:problem][:correct_type].to_i}, answer_question_attr[1])
      #创建标签
      if !params[:tag].nil? and params[:tag].strip != ""
        tag_name = params[:tag].strip.split(" ")
        @question.question_tags(Tag.create_tag(tag_name))
      end
      score_arr[@question.id] = params[:problem][:score].to_i
    end
    @problem.update_problem_tags
    create_xml(@problem, score_arr)
    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"
  end

  #组装答案和选项
  def answer_text(problem_type, attr_num, answer,question_id="")
    answer_question_attr = []
    attrs_array = []
    if problem_type == Problem::QUESTION_TYPE[:SINGLE_CHOSE]
      answer_index = params["attr_key#{question_id}"].to_i
      answer_question_attr << params["attr#{answer_index}_value#{question_id}"]
      (1..attr_num).each do |i|
        if !params["attr#{i}_value#{question_id}"].nil? && params["attr#{i}_value#{question_id}"] != ""
          attrs_array << params["attr#{i}_value#{question_id}"]
        end
      end
      answer_question_attr << attrs_array
    elsif problem_type == Problem::QUESTION_TYPE[:MORE_CHOSE]
      answer_index = []
      (1..attr_num).each do |i|    
        if !params["attr#{i}_key#{question_id}"].nil? and params["attr#{i}_key#{question_id}"] != ""
          attr_key = params["attr#{i}_key#{question_id}"].to_i
          answer_index << params["attr#{attr_key}_value#{question_id}"]
        end
        if !params["attr#{i}_value#{question_id}"].nil? && params["attr#{i}_value#{question_id}"] != ""
          attrs_array << params["attr#{i}_value#{question_id}"]
        end
      end
      answer_question_attr << answer_index.join(";|;")
      answer_question_attr << attrs_array
    elsif problem_type == Problem::QUESTION_TYPE[:JUDGE]
      answer_question_attr << params["attr_key#{question_id}"].to_i
      answer_question_attr << []
    elsif problem_type == Problem::QUESTION_TYPE[:SINGLE_CALK] or problem_type == Problem::QUESTION_TYPE[:CHARACTER]
      answer_question_attr << answer
      answer_question_attr << []
    end
    return answer_question_attr
  end

  def update_problem
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    @problem = Problem.find(params[:problem][:problem_id].to_i)
    #更新题面
    @problem.update_attributes(:title=>params[:problem][:title].strip, :updated_at=>Time.now)

    #打开xml
    url = File.open "#{Constant::PAPER_PATH}/#{params[:problem][:paper_id].to_i}.xml"
    doc = Problem.open_xml(url)
    #更新提点
    score_arr = {}
    if @problem.types == Problem::QUESTION_TYPE[:COLLIGATION]
      score_arr = Question.update_colligation_questions(@problem,
        Question.colligation_questions(params["edit_coll_question_" + params[:problem][:problem_id]]), "update")
      score_arr = @problem.old_score(score_arr, doc, params[:problem][:problem_xpath])
    else
      answer_question_attr = answer_text(@problem.types,
        params[:problem][:attr_sum].to_i, params[:problem][:answer],params[:problem][:question_id])
      @question = Question.update_question(params[:problem][:question_id],
        {:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis].strip,
          :correct_type => params[:problem][:correct_type].to_i}, answer_question_attr[1])
      if !params[:tag].nil? and params[:tag].strip != ""
        tag_name = params[:tag].strip.split(" ")
        @question.question_tags(Tag.create_tag(tag_name))
      end
      score_arr[@question.id] = params[:problem][:score].to_i
    end
    @problem.update_problem_tags

    #更新xml
    doc = Problem.remove_problem_xml(doc, params[:problem][:problem_xpath])
    doc = @problem.create_problem_xml(doc, params[:problem][:block_id], {:score => score_arr})
    Problem.write_xml(url, doc)
    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"

  end

  def mavin_problem
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    content = params[:problem][:title].gsub("<br />", "")
    #切割字符串,简答题以“{{}}”标志，其他题目都以“[[]]”标志,“||”后面为标签，“||”前为答案，
    #“|”用来区分选择题正误，前面为正确答案，后面为错误答案，“；”用来标识多个选项
    unless content.nil? or content == ""
      problem_correct_type = 0
      question_tmp = {} #用来记录初步分离的提点
      questions = [] #用来记录所有的提点
      problem_title = content.gsub(/\[\[(.|\n)+?\]\]/, "______").gsub(/\{\{(.|\n)+?\}\}/, "______")
      .gsub(/\[\{(.|\n)+?\}\]/, "").gsub(/\[\((.|\n)+?\)\]/, "")
      #非简答题以外的题
      if content.include? "[["
        question_tmp = Question.generate_question_hash(question_tmp, "]]", "[[", content)
        character_question = Question.generate_question_hash(question_tmp, "}}", "{{", content)
        question_tmp = question_tmp.merge(character_question)
        questions = Question.generate_question_for_database(question_tmp)
        if question_tmp.length == 1     #非综合题以外的题
          problem_correct_type = questions[0][:correct_type]
        else
          problem_correct_type = Problem::QUESTION_TYPE[:COLLIGATION]
        end
      elsif content.include? "{{"
        question_tmp = Question.generate_question_hash(question_tmp, "}}", "{{", content)
        questions = Question.generate_question_for_database(question_tmp)
        problem_correct_type = Problem::QUESTION_TYPE[:CHARACTER]
      end
      #保存题目和提点，并返回所有提点的分值
      scores = Question.generate_score_or_analysis(content, ")]", "[(")
      analysis = Question.generate_score_or_analysis(content, "}]", "[{")
      score_arr = {}
      @problem = Problem.create_problem(@paper, 
        {:title => problem_title, :types => problem_correct_type, :complete_title => content})
      (0..questions.length-1).each do |i|
        questions[i][:analysis] = analysis[i].nil? ? "" : analysis[i]
        @question = Question.create_question(@problem,
          {:answer => questions[i][:answer], :analysis => questions[i][:analysis],
            :correct_type => questions[i][:correct_type].to_i}, questions[i][:question_attr])
        score_arr[@question.id] = scores[i].nil? ? 0 : scores[i]
        #创建标签
        if !questions[i][:tag].nil? and questions[i][:tag] != ""
          tag_name = questions[i][:tag].split(" ")
          @question.question_tags(Tag.create_tag(tag_name))
        end
      end
      @problem.update_problem_tags
      create_xml(@problem, score_arr)
    end   
    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"
  end
  

  def create_xml(problem, score_arr)
    #更新试卷xml
    url = File.open "#{Constant::PAPER_PATH}/#{params[:problem][:paper_id].to_i}.xml"
    doc = problem.create_problem_xml(Problem.open_xml(url), params[:problem][:block_id],
      {:score => score_arr})
    Problem.write_xml(url, doc)
  end

    def destroy
    Problem.find(params[:id]).destroy
    redirect_to "/item_pools/index_search"
  end

end
