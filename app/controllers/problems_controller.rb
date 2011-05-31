class ProblemsController < ApplicationController
  before_filter :access?

  require 'rexml/document'
  include REXML
  
  def create

    @paper = Paper.find(params[:problem][:paper_id].to_i)
    #创建题目
    @problem = Problem.create_problem(@paper, {:title=>params[:problem][:title], :types => params[:real_type].to_i})
    #创建题点
    score_arr = {}
    if params[:real_type].to_i == Problem::QUESTION_TYPE[:COLLIGATION]
      score_arr = update_colligation_questions(@problem,
        colligation_questions(params["single_question_#{params[:problem][:block_id]}"]), "create")
    else
      answer_question_attr = answer_text(params[:problem][:correct_type].to_i,
        params[:problem][:attr_sum].to_i, params[:problem][:answer])
      @question = Question.create_question(@problem,
        {:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis],
          :correct_type => params[:problem][:correct_type].to_i}, answer_question_attr[1])
      #创建标签
      if !params[:tag].nil? and params[:tag] != ""
        tag_name = params[:tag].split(" ")
        @question.question_tags(Tag.create_tag(tag_name))
      end
      score_arr[@question.id] = params[:problem][:score].to_i
    end
    @problem.update_problem_tags
    #更新试卷xml
    url = File.open "#{papers_path}/#{params[:problem][:paper_id].to_i}.xml"
    doc = @problem.create_problem_xml(Problem.open_xml(url), params[:problem][:block_id], {:score => score_arr})
    Problem.write_xml(url, doc)
    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"
  end

  #综合题的提点信息整理
  def colligation_questions(question_str)
    all_question = []
    if question_str != ""
      questions = question_str.split("||")
      questions.each do |question|
        if question != ""
          question_hash = {}
          key_values = question.gsub("{", "").gsub("}", "").split(",|,")
          key_values.each do |key_value|
            attrs = key_value.split("=>")
            question_hash[attrs[0]] = attrs[1]
          end
          question_attr = []
          unless (question_hash["attr_value"].nil? or question_hash["attr_value"] == "")
            question_attr = question_hash["attr_value"].split(";|;")
          end
          question_hash["question_attr"] = question_attr
          all_question << question_hash
        end
      end
    end
    return all_question
  end

  #更新综合题的所有提点信息,update_flag有两个值，如果是create，则表示是新增，如果是update，则表示是更新
  def update_colligation_questions(problem, questions, update_flag)
    score_arr = {}
    questions.each do |question_hash|
      if update_flag == "create"
        question = Question.create_question(problem,
          {:answer => question_hash["answer"], :analysis => question_hash["analysis"],
            :correct_type => question_hash["correct_type"].to_i, :description => question_hash["diescription"]},
          question_hash["question_attr"])
      else
        question = Question.update_question(question_hash["question_id"].to_i,
          {:answer => question_hash["answer"], :analysis => question_hash["analysis"],
            :description => question_hash["diescription"]}, question_hash["question_attr"])
      end
      #创建标签
      if !question_hash["tag"].nil? and question_hash["tag"] != ""
        tag_name = question_hash["tag"].split(" ")
        question.question_tags(Tag.create_tag(tag_name))
      end
      score_arr[question.id] = question_hash["score"].to_i
    end
    return score_arr
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
          answer_index << params["attr#{attr_key}_value"]
        end
        attrs_array << params["attr#{i}_value"]
      end
      answer_question_attr << answer_index.join(";|;")
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
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    @problem = Problem.find(params[:problem][:problem_id].to_i)
    #更新题面
    @problem.update_attributes(:title=>params[:problem][:title], :updated_at=>Time.now)

    #打开xml
    url = File.open "#{papers_path}/#{params[:problem][:paper_id].to_i}.xml"
    doc = Problem.open_xml(url)
    #更新提点
    score_arr = {}
    if @problem.types == Problem::QUESTION_TYPE[:COLLIGATION]
      score_arr = update_colligation_questions(@problem,
        colligation_questions(params["edit_coll_question_" + params[:problem][:problem_id]]), "update")
      score_arr = @problem.old_score(score_arr, doc, params[:problem][:problem_xpath])
    else
      answer_question_attr = answer_text(@problem.types,
        params[:problem][:attr_sum].to_i, params[:problem][:answer])
      @question = Question.update_question(params[:problem][:question_id],
        {:answer=>answer_question_attr[0], :analysis => params[:problem][:analysis],
          :correct_type => params[:problem][:correct_type].to_i}, answer_question_attr[1])
      if !params[:tag].nil? and params[:tag] != ""
        tag_name = params[:tag].split(" ")
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
end
