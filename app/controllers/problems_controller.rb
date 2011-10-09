# encoding: utf-8
class ProblemsController < ApplicationController
  before_filter :access?
  
  def create
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    #创建题目
    @problem = Problem.create_problem(@paper, {:title=>params[:problem][:title].strip, :types => params[:real_type].to_i,:status=>Problem::PROBLEM_STATUS[:USED]})
    #    @problem.update_attributes(:title=>@problem.title.gsub("audio_play('x')","audio_play(#{@problem.id})").gsub("id=\"audio_x\"","id='audio_#{@problem.id}'").gsub("id=\"audio_control_x\"","id='audio_control_#{@problem.id}'").gsub("problem_x_dropplace","problem_#{@problem.id}_dropplace").gsub("problem_x_writefont","problem_#{@problem.id}_writefont"))
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
      score_arr[@question.id] = params[:problem][:score].to_f
    end
    @problem.update_problem_tags
    create_xml(@problem, score_arr)
    redirect_to  "/papers/#{params[:problem][:paper_id]}/new_step_two"
  end

  
  def update_problem
    @paper = Paper.find(params[:problem][:paper_id].to_i)
    @problem = Problem.find(params[:problem][:problem_id].to_i)
    #更新题面
    @problem.update_attributes(:title=>params[:problem][:title].strip, :updated_at=>Time.now)
    #       @problem.update_attributes(:title=>@problem.title.gsub("audio_play('x')","audio_play(#{@problem.id})").gsub("id=\"audio_x\"","id='audio_#{@problem.id}'").gsub("id=\"audio_control_x\"","id='audio_control_#{@problem.id}'").gsub("problem_x_dropplace","problem_#{@problem.id}_dropplace").gsub("problem_x_writefont","problem_#{@problem.id}_writefont"))
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
      score_arr[@question.id] = params[:problem][:score].to_f
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
        {:title => problem_title, :types => problem_correct_type, :complete_title => content,:status=>Problem::PROBLEM_STATUS[:USED]})
      (0..questions.length-1).each do |i|
        questions[i][:analysis] = analysis[i].nil? ? "" : analysis[i]
        @question = Question.create_question(@problem,
          {:answer => questions[i][:answer], :analysis => questions[i][:analysis],
            :correct_type => questions[i][:correct_type].to_i}, questions[i][:question_attr])
        score_arr[@question.id] = scores[i].nil? ? 0.0 : scores[i]
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
    @problem = Problem.find(params[:id])
    if @problem.status==1
      flash[:error]="无法删除，该题已经被使用！"
    else
      @problem.destroy
      flash[:notice]="删除成功！"
    end
    redirect_to request.referer
  end
  
  def des
    @problem=Problem.find_by_sql("select * from problems where id in (#{params[:exam_getvalue]})")
    @problem.each do |problem|
      if problem.status==1
        flash[:error]="未使用的的题已删除，已被使用的题无法删除！"
      else
        problem.destroy
        flash[:notice]="删除成功！"
      end
    end
    redirect_to "/item_pools/index_search"
  end


  def create_part_description
    url="#{Constant::PAPER_PATH}/#{params[:problem][:paper_id].to_i}.xml"
    doc=Problem.open_xml(File.open url).root
    part_description=doc.elements["blocks/block[@id='#{params[:id]}']/problems"]
    parts=part_description.get_elements("//part_description")
    ids=[]
    parts.each do |part|
      ids << part.attributes["part_id"].to_i
    end unless parts==[]
    description=part_description.add_element("problem").add_element("part_description").add_text(params["mavin_problem_title_#{params[:id]}"])
    unless ids == []
      description.add_attribute("part_id","#{ids.sort.last+1}")
    else
      description.add_attribute("part_id","1")
    end
    write_xml(url,doc)
    redirect_to request.referer
  end

  def load_edit_part
    xml = REXML::Document.new(File.new("#{Constant::PAPER_PATH}/#{params[:paper_id].to_i}.xml")).root
    problem=xml.elements["blocks/block[@id='#{params[:block_id]}']/problems//part_description[@part_id='#{params[:id]}']"]
    render :partial=>"/papers/edit_problem_state",:object=>[problem,params[:paper_id],params[:block_id]]
  end

  def update_part_description
    url="#{Constant::PAPER_PATH}/#{params[:paper_id].to_i}.xml"
    doc=Problem.open_xml(File.open url).root
    doc.elements["blocks/block[@id='#{params[:block_id]}']/problems//part_description[@part_id='#{params[:id]}']"].text=params["mavin_problem_title_#{params[:id]}"]
    write_xml(url,doc)
    redirect_to request.referer
  end
  def description_destroy
    url="#{Constant::PAPER_PATH}/#{params[:paper_id].to_i}.xml"
    doc=Problem.open_xml(File.open url).root
    doc.delete_element(params[:problem_path])
    write_xml(url,doc)
    redirect_to request.referer
  end
end
